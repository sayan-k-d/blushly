import '../db/app_database.dart';
import '../models/product_model.dart';

class ProductRepository {
  Future<int> addProduct(Product product) async {
    if (product.name.trim().isEmpty) {
      throw Exception('Product name required');
    }

    if (product.quantity < 0) {
      throw Exception('Quantity cannot be negative');
    }

    if (product.purchasePrice < 0 || product.sellingPrice < 0) {
      throw Exception('Invalid price');
    }

    final db = await AppDatabase.instance.database;

    return await db.insert('products', {
      ...product.toMap(),
      'created_at': product.createdAt ?? DateTime.now().toIso8601String(),
    });
  }

  Future<List<Product>> getProducts({bool includeInactive = false}) async {
    final db = await AppDatabase.instance.database;

    final result = await db.query(
      'products',
      where: includeInactive ? null : 'is_active = 1',
      orderBy: 'created_at DESC',
    );

    return result.map((e) => Product.fromMap(e)).toList();
  }

  Future<int> updateProduct(Product product) async {
    if (product.id == null) {
      throw Exception('Product ID missing');
    }

    final db = await AppDatabase.instance.database;

    // Only update allowed fields (NO blind overwrite)
    final data = <String, dynamic>{
      'name': product.name,
      'category_id': product.categoryId,
      'selling_price': product.sellingPrice,
      'purchase_price': product.purchasePrice,
      'expiry_date': product.expiryDate,
      'low_stock_threshold': product.lowStockThreshold,
      'image_path': product.imagePath,
    };
    return await db.update(
      'products',
      data,
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  /// 🔒 SAFE DELETE (SOFT DELETE)
  Future<int> deleteProduct(int id) async {
    final db = await AppDatabase.instance.database;

    return await db.update(
      'products',
      {'is_active': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
