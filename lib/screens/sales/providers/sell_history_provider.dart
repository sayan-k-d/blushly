import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/db/app_database.dart';
import 'sell_history_filter_provider.dart';

final sellHistoryProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final db = await AppDatabase.instance.database;

  final search = ref.watch(sellHistorySearchProvider);
  final categoryId = ref.watch(sellHistoryCategoryProvider);
  final dateRange = ref.watch(sellHistoryDateRangeProvider);
  final saleFilter = ref.watch(saleFilterProvider);

  final conditions = <String>[];
  final args = <dynamic>[];

  if (search.isNotEmpty) {
    conditions.add('p.name LIKE ?');
    args.add('%$search%');
  }

  if (categoryId != null) {
    conditions.add('p.category_id = ?');
    args.add(categoryId);
  }

  if (saleFilter == SaleFilter.dueOnly) {
    conditions.add('s.is_due = 1');
  }

  if (dateRange != null) {
    final start = DateTime(
      dateRange.start.year,
      dateRange.start.month,
      dateRange.start.day,
    );

    final end = DateTime(
      dateRange.end.year,
      dateRange.end.month,
      dateRange.end.day,
      23,
      59,
      59,
      999,
    );

    conditions.add('s.created_at BETWEEN ? AND ?');
    args.add(start.toIso8601String());
    args.add(end.toIso8601String());
  }

  final whereClause =
      conditions.isEmpty ? '' : 'WHERE ${conditions.join(' AND ')}';

  final result = await db.rawQuery('''
    SELECT
      p.id AS product_id,
      p.name AS product_name,
      c.name AS category_name,
      p.purchase_price AS purchase_price,
      p.selling_price AS selling_price,

      s.is_price_overridden,
      s.is_due,
      s.due_amount,

      DATE(s.created_at) AS sale_date,

      SUM(s.quantity) AS total_quantity,
      SUM(s.quantity * s.selling_price) AS total_amount,
      SUM(s.profit) AS total_profit,

      MAX(s.created_at) AS last_sold_at

    FROM sales s
    JOIN products p ON p.id = s.product_id
    LEFT JOIN categories c ON c.id = p.category_id

    $whereClause

    GROUP BY p.id, DATE(s.created_at)
    ORDER BY last_sold_at DESC
  ''', args);

  return result;
});
