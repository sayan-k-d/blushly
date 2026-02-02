import 'package:blushly/core/utils/time_ago.dart';
import 'package:blushly/data/db/app_database.dart';
import 'package:blushly/data/models/activity_item.dart';
import 'package:blushly/screens/dashboard/providers/date_filter_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recentActivityProvider = FutureProvider<List<ActivityItem>>((ref) async {
  final db = await AppDatabase.instance.database;
  final filter = ref.watch(dateFilterProvider);

  // 🔹 Date condition
  final salesDateCondition =
      filter == DateFilter.today
          ? "DATE(s.created_at) = DATE('now', 'localtime')"
          : "strftime('%Y-%m', s.created_at) = strftime('%Y-%m', 'now', 'localtime')";

  final restockDateCondition =
      filter == DateFilter.today
          ? "DATE(r.created_at) = DATE('now', 'localtime')"
          : "strftime('%Y-%m', r.created_at) = strftime('%Y-%m', 'now', 'localtime')";

  final List<ActivityItem> activities = [];

  /* ----------------------------------------------------
   * 1️⃣ BARGAIN SALE — Highest adjusted impact
   * -------------------------------------------------- */
  final bargain = await db.rawQuery('''
    SELECT
      p.name AS product_name,
      SUM(s.quantity) AS total_qty,
      MAX(s.created_at) AS last_time
    FROM sales s
    JOIN products p ON p.id = s.product_id
    WHERE s.is_price_overridden = 1
      AND $salesDateCondition
    GROUP BY p.id
    ORDER BY total_qty DESC
    LIMIT 1
  ''');

  if (bargain.isNotEmpty) {
    activities.add(
      ActivityItem(
        type: ActivityType.bargainSale,
        title: "${bargain.first['product_name']} sold",
        subtitle: "Price adjusted • Qty ${bargain.first['total_qty']}",
        time: timeAgo(bargain.first['last_time'] as String),
      ),
    );
  }

  /* ----------------------------------------------------
   * 2️⃣ RESTOCK — Relevant restock crossing threshold
   * -------------------------------------------------- */
  final restock = await db.rawQuery('''
    SELECT
      p.name AS product_name,
      SUM(r.quantity_added) AS restocked_qty,
      MAX(r.created_at) AS last_time
    FROM restocks r
    JOIN products p ON p.id = r.product_id
    WHERE $restockDateCondition 
      AND p.quantity >= p.low_stock_threshold
    GROUP BY p.id
    ORDER BY restocked_qty DESC
    LIMIT 1
  ''');

  if (restock.isNotEmpty) {
    activities.add(
      ActivityItem(
        type: ActivityType.restock,
        title: "${restock.first['product_name']} restocked",
        subtitle: "Added ${restock.first['restocked_qty']} units",
        time: timeAgo(restock.first['last_time'] as String),
      ),
    );
  }

  /* ----------------------------------------------------
   * 3️⃣ SALE — Highest selling product
   * -------------------------------------------------- */
  final sale = await db.rawQuery('''
    SELECT
      p.name AS product_name,
      SUM(s.quantity) AS total_qty,
      MAX(s.created_at) AS last_time
    FROM sales s
    JOIN products p ON p.id = s.product_id
    WHERE $salesDateCondition
    GROUP BY p.id
    ORDER BY total_qty DESC
    LIMIT 1
  ''');

  if (sale.isNotEmpty) {
    activities.add(
      ActivityItem(
        type: ActivityType.sale,
        title: "${sale.first['product_name']} sold",
        subtitle: "Qty ${sale.first['total_qty']}",
        time: timeAgo(sale.first['last_time'] as String),
      ),
    );
  }

  return activities;
});
