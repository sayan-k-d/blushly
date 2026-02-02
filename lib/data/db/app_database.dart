import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();
  static Database? _database;

  AppDatabase._internal();

  static const int _dbVersion = 2; // ⬅️ increment when schema changes
  static const String _dbName = 'cosmetics_shop.db';
  bool get isOpen => _database != null;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // 🟢 INITIAL SCHEMA (v1)
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color TEXT,
        icon TEXT,
        is_active INTEGER DEFAULT 1,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category_id INTEGER,
        purchase_price REAL,
        selling_price REAL,
        quantity INTEGER,
        expiry_date TEXT,
        image_path TEXT,
        low_stock_threshold INTEGER DEFAULT 5,
        is_active INTEGER DEFAULT 1,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER,
        quantity INTEGER,
        selling_price REAL,
        profit REAL,
        is_price_overridden INTEGER DEFAULT 0,
        is_due INTEGER DEFAULT 0,
        due_amount REAL DEFAULT 0,
        customer_name TEXT,
        customer_phone TEXT,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE restocks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER,
        quantity_added INTEGER,
        purchase_price REAL,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE due_payments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sale_id INTEGER,
        amount_paid REAL,
        created_at TEXT
      )
    ''');

    await db.execute('''
    CREATE TABLE cloud_backups (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      drive_file_id TEXT,
      created_at TEXT
    );
    ''');

    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE app_meta (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  // 🟡 MIGRATIONS (v1 → v2, v2 → v3, ...)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // if (oldVersion < 2) {
    //   await _migrateV2(db);
    // }

    // Future:
    // if (oldVersion < 3) await _migrateV3(db);
    // if (oldVersion < 4) await _migrateV4(db);
    // if (oldVersion < 6) await _migrateV5(db);
  }

  // 🔵 v2: Due sales support
  // Future<void> _migrateV2(Database db) async {
  // await db.execute('''
  //   CREATE TABLE app_meta (
  //     key TEXT PRIMARY KEY,
  //     value TEXT NOT NULL
  //   )
  // ''');
  // }

  // Future<void> _migrateV3(Database db) async {
  //   await db.execute('''
  //     CREATE TABLE due_payments (
  //       id INTEGER PRIMARY KEY AUTOINCREMENT,
  //       sale_id INTEGER,
  //       amount_paid REAL,
  //       created_at TEXT
  //     )
  //   ''');
  // }

  // Future<void> _migrateV4(Database db) async {
  //   await db.execute('''
  //     ALTER TABLE products ADD COLUMN is_active INTEGER DEFAULT 1;
  //   ''');
  //   await db.execute('''
  //     ALTER TABLE categories ADD COLUMN is_active INTEGER DEFAULT 1;
  //   ''');
  // }

  // Future<void> _migrateV5(Database db) async {
  //   await db.execute('''
  //   CREATE TABLE cloud_backups (
  //     id INTEGER PRIMARY KEY AUTOINCREMENT,
  //     drive_file_id TEXT,
  //     created_at TEXT
  //   );

  //   ''');
  // }

  // 🔥 OPTIONAL — DEV ONLY
  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    if (_database != null) {
      await _database!.close();
      _database = null;
    }

    await deleteDatabase(path);
    _database = await _initDB();
  }
}
