import 'package:blushly/data/db/app_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dueHistoryProvider =
    FutureProvider.family<List<Map<String, dynamic>>, int>((ref, saleId) async {
      final db = await AppDatabase.instance.database;

      return await db.rawQuery(
        '''
    SELECT
      amount_paid,
      created_at
    FROM due_payments
    WHERE sale_id = ?
    ORDER BY created_at DESC
  ''',
        [saleId],
      );
    });
