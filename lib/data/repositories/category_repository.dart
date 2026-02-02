import '../db/app_database.dart';
import '../models/category_model.dart';

class CategoryRepository {
  Future<int> addCategory(Category category) async {
    final name = category.name.trim();

    if (name.isEmpty) {
      throw Exception('Category name required');
    }

    final db = await AppDatabase.instance.database;

    // 🔒 Prevent duplicate category names
    final existing = await db.query(
      'categories',
      where: 'LOWER(name) = ? AND is_active = 1',
      whereArgs: [name.toLowerCase()],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      throw Exception('Category already exists');
    }

    return await db.insert('categories', {
      ...category.toMap(),
      'name': name,
      'created_at': category.createdAt ?? DateTime.now().toIso8601String(),
      'is_active': 1,
    });
  }

  Future<List<Category>> getCategories({bool includeInactive = false}) async {
    final db = await AppDatabase.instance.database;

    final result = await db.query(
      'categories',
      where: includeInactive ? null : 'is_active = 1',
      orderBy: 'created_at DESC',
    );

    return result.map((e) => Category.fromMap(e)).toList();
  }

  Future<int> updateCategory(Category category) async {
    if (category.id == null) {
      throw Exception('Category ID missing');
    }

    final name = category.name.trim();
    if (name.isEmpty) {
      throw Exception('Category name required');
    }

    final db = await AppDatabase.instance.database;

    // 🔒 Prevent rename conflict
    final existing = await db.query(
      'categories',
      where: 'LOWER(name) = ? AND id != ? AND is_active = 1',
      whereArgs: [name.toLowerCase(), category.id],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      throw Exception('Category name already exists');
    }

    return await db.update(
      'categories',
      {'name': name, 'color': category.color, 'icon': category.icon},
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  /// 🔒 SAFE DELETE (SOFT DELETE)
  Future<int> deleteCategory(int id) async {
    final db = await AppDatabase.instance.database;

    return await db.update(
      'categories',
      {'is_active': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
