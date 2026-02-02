import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/db/app_database.dart';

final sellHistoryDetailProvider = FutureProvider.family<
  List<Map<String, dynamic>>,
  ({int productId, String saleDate})
>((ref, args) async {
  final db = await AppDatabase.instance.database;
  // debugPrint(
  //   "DETAIL QUERY → productId=${args.productId}, date=${args.saleDate}",
  // );
  final res = await db.rawQuery(
    '''
    SELECT
      s.quantity,
      s.selling_price,
      s.profit,
      s.is_price_overridden,
      s.is_due,
      s.due_amount,
      s.created_at
    FROM sales s
    WHERE s.product_id = ?
      AND substr(created_at, 1, 10) = ?
    ORDER BY s.created_at DESC
  ''',
    [args.productId, args.saleDate],
  );
  debugPrint('DETAIL RESULT → $res');
  return res;
});

class SellHistoryDetailArgs {
  final int productId;
  final String saleDate; // yyyy-MM-dd

  SellHistoryDetailArgs({required this.productId, required this.saleDate});
}
