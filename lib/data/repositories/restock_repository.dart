import '../db/app_database.dart';

class RestockRepository {
  Future<void> restockProduct({
    required int productId,
    required int quantity,
    double? purchasePrice,
  }) async {
    if (quantity <= 0) {
      throw Exception('Invalid restock quantity');
    }

    final db = await AppDatabase.instance.database;

    await db.transaction((txn) async {
      // 1️⃣ SAFELY UPDATE PRODUCT STOCK
      final updatedRows = await txn.rawUpdate(
        '''
        UPDATE products
        SET quantity = quantity + ?
        WHERE id = ?
        ''',
        [quantity, productId],
      );

      if (updatedRows == 0) {
        throw Exception('Product not found');
      }

      // 2️⃣ LOG RESTOCK ONLY IF PRODUCT UPDATE SUCCEEDS
      await txn.insert('restocks', {
        'product_id': productId,
        'quantity_added': quantity,
        'purchase_price': purchasePrice,
        'created_at': DateTime.now().toIso8601String(),
      });
    });
  }
}
