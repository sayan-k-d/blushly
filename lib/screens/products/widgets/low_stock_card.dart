import 'package:blushly/data/models/product_model.dart';
import 'package:blushly/screens/restock/restock_sheet.dart';
import 'package:flutter/material.dart';

class LowStockCard extends StatelessWidget {
  final Product product;

  const LowStockCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final isCritical = product.quantity <= (product.lowStockThreshold / 2);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:
            isCritical
                ? Colors.red.withOpacity(0.05)
                : Colors.orange.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isCritical
                  ? Colors.red.withOpacity(0.4)
                  : Colors.orange.withOpacity(0.4),
        ),
      ),
      child: Row(
        children: [
          // 🔴 Indicator
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color:
                  isCritical
                      ? Colors.red.withOpacity(0.15)
                      : Colors.orange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isCritical ? Icons.warning_rounded : Icons.inventory_2,
              color: isCritical ? Colors.red : Colors.orange,
            ),
          ),

          const SizedBox(width: 14),

          // 🧾 Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Stock: ${product.quantity} • Threshold: ${product.lowStockThreshold}",
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ],
            ),
          ),

          // ➕ Restock action
          IconButton(
            icon: const Icon(Icons.add_circle),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (_) => RestockSheet(product: product),
              );
            },
          ),
        ],
      ),
    );
  }
}
