import 'package:blushly/data/db/app_database.dart';

class DueRepository {
  Future<void> recordPayment({
    required String customerName,
    String? customerPhone,
    required double amountPaid,
  }) async {
    if (amountPaid <= 0) {
      throw Exception('Invalid payment amount');
    }

    final db = await AppDatabase.instance.database;

    await db.transaction((txn) async {
      // 1️⃣ FETCH DUE SALES INSIDE TRANSACTION (FIFO)
      final sales = await txn.rawQuery(
        '''
        SELECT id, due_amount
        FROM sales
        WHERE is_due = 1
          AND customer_name = ?
          AND customer_phone IS ?
        ORDER BY created_at ASC
      ''',
        [customerName, customerPhone],
      );

      if (sales.isEmpty) {
        throw Exception('No due records found');
      }

      double remaining = amountPaid;

      for (final s in sales) {
        if (remaining <= 0) break;

        final saleId = s['id'] as int;
        final due = (s['due_amount'] as num).toDouble();

        if (due <= 0) continue;

        final deduction = remaining >= due ? due : remaining;

        // 2️⃣ INSERT PAYMENT RECORD
        await txn.insert('due_payments', {
          'sale_id': saleId,
          'amount_paid': deduction,
          'created_at': DateTime.now().toIso8601String(),
        });

        final updatedDue = due - deduction;

        // 3️⃣ UPDATE SALE SAFELY
        final updatedRows = await txn.update(
          'sales',
          {
            'due_amount': updatedDue,
            'is_due': updatedDue > 0 ? 1 : 0,
            'created_at': DateTime.now().toIso8601String(),
          },
          where: 'id = ? AND due_amount = ?',
          whereArgs: [saleId, due],
        );

        if (updatedRows == 0) {
          throw Exception('Concurrent due update detected');
        }

        remaining -= deduction;
      }

      // 4️⃣ OPTIONAL: PREVENT SILENT OVERPAYMENT
      if (remaining > 0) {
        throw Exception('Payment exceeds total due amount');
      }
    });
  }
}
