import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/db/app_database.dart';

final restockHistoryProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final db = await AppDatabase.instance.database;

  final result = await db.rawQuery('''
    SELECT
      p.id AS product_id,
      p.name AS product_name,

      SUM(r.quantity_added) AS total_quantity,
      SUM(r.quantity_added * IFNULL(r.purchase_price, 0)) AS total_amount,
      COUNT(r.id) AS restock_count,
      MAX(r.created_at) AS last_restock_at

    FROM restocks r
    JOIN products p ON p.id = r.product_id

    WHERE substr(r.created_at, 1, 7) = strftime('%Y-%m', 'now', 'localtime')

    GROUP BY p.id
    ORDER BY last_restock_at DESC
  ''');
  // WHERE substr(r.created_at, 1, 7) = substr(date('now'), 1, 7)

  return result;
});
