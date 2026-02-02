import 'package:blushly/data/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductPreview extends StatelessWidget {
  final Product product;

  const ProductPreview({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isLowStock = product.quantity <= 5;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.pink.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color:
              isLowStock
                  ? Colors.red.withOpacity(0.4)
                  : Colors.pink.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // Product Icon / Image Placeholder
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: Colors.pink.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.spa, color: Colors.pink, size: 30),
          ),

          const SizedBox(width: 14),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "₹${product.sellingPrice}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Text(
                      "Stock: ${product.quantity}",
                      style: TextStyle(
                        fontSize: 12,
                        color: isLowStock ? Colors.red : Colors.grey[700],
                      ),
                    ),
                    if (isLowStock) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.warning, color: Colors.red, size: 14),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
