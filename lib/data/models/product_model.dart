class Product {
  final int? id;
  final String name;
  final int categoryId;
  final double purchasePrice;
  final double sellingPrice;
  final int quantity;
  final String? expiryDate;
  final String? imagePath;
  final int lowStockThreshold;
  final String createdAt;

  Product({
    this.id,
    required this.name,
    required this.categoryId,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.quantity,
    this.expiryDate,
    this.imagePath,
    this.lowStockThreshold = 5,
    required this.createdAt,
  });

  bool get isLowStock => quantity <= lowStockThreshold;

  Product copyWith({
    int? id,
    String? name,
    int? categoryId,
    double? purchasePrice,
    double? sellingPrice,
    int? quantity,
    String? expiryDate,
    String? imagePath,
    int? lowStockThreshold,
    String? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      quantity: quantity ?? this.quantity,
      expiryDate: expiryDate ?? this.expiryDate,
      imagePath: imagePath ?? this.imagePath,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'category_id': categoryId,
    'purchase_price': purchasePrice,
    'selling_price': sellingPrice,
    'quantity': quantity,
    'expiry_date': expiryDate,
    'image_path': imagePath,
    'low_stock_threshold': lowStockThreshold,
    'created_at': createdAt,
  };

  factory Product.fromMap(Map<String, dynamic> map) => Product(
    id: map['id'],
    name: map['name'],
    categoryId: map['category_id'],
    purchasePrice: map['purchase_price'],
    sellingPrice: map['selling_price'],
    quantity: _toInt(map['quantity']),
    expiryDate: map['expiry_date'],
    imagePath: map['image_path'],
    lowStockThreshold: map['low_stock_threshold'] ?? 5,
    createdAt: map['created_at'],
  );
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}
