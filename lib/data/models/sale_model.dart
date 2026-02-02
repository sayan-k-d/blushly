class Sale {
  final int? id;
  final int productId;
  final int quantity;
  final double sellingPrice;
  final double profit;
  final int? is_due;
  final double? due_amount;
  final String? customer_name;
  final String? customer_phone;
  final String createdAt;

  Sale({
    this.id,
    required this.productId,
    required this.quantity,
    required this.sellingPrice,
    required this.profit,
    required this.createdAt,
    this.is_due,
    this.due_amount,
    this.customer_name,
    this.customer_phone,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'product_id': productId,
    'quantity': quantity,
    'selling_price': sellingPrice,
    'profit': profit,
    'is_due': is_due,
    'due_amount': due_amount,
    'customer_name': customer_name,
    'customer_phone': customer_phone,
    'created_at': createdAt,
  };
}
