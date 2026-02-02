import '../db/app_database.dart';

class SalesRepository {
  Future<void> makeSale({
    required int productId,
    required int quantity,
    required double purchasePrice,
    required double sellingPrice,
    double? overriddenSellingPrice,

    bool isDue = false,
    double dueAmount = 0,
    String? customerName,
    String? customerPhone,
  }) async {
    final db = await AppDatabase.instance.database;
    final actualSellingPrice = overriddenSellingPrice ?? sellingPrice;
    final profit = (actualSellingPrice - purchasePrice) * quantity;

    await db.transaction((txn) async {
      // 1️⃣ SAFELY REDUCE STOCK (DB LEVEL CHECK)
      // final updatedRows = await txn.update(
      //   'products',
      //   {'quantity': 'quantity - $quantity'},
      //   where: 'id = ? AND quantity >= ?',
      //   whereArgs: [productId, quantity],
      // );

      final updatedRows = await txn.rawUpdate(
        '''
        UPDATE products
        SET quantity = quantity - ?
        WHERE id = ? AND quantity >= ?
        ''',
        [quantity, productId, quantity],
      );

      if (updatedRows == 0) {
        throw Exception('Insufficient stock');
      }

      // 2️⃣ INSERT SALE ONLY IF STOCK UPDATE SUCCEEDED
      await txn.insert('sales', {
        'product_id': productId,
        'quantity': quantity,
        'selling_price': actualSellingPrice,
        'profit': profit,
        'is_price_overridden': overriddenSellingPrice != null ? 1 : 0,

        'is_due': isDue ? 1 : 0,
        'due_amount': isDue ? dueAmount : 0,
        'customer_name': isDue ? customerName : null,
        'customer_phone': isDue ? customerPhone : null,

        'created_at': DateTime.now().toIso8601String(),
      });
    });
  }
}
