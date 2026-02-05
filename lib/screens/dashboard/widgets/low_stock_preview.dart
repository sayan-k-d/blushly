import 'package:blushly/core/widgets/empty_state.dart';
import 'package:blushly/core/widgets/entry_animate.dart';
import 'package:blushly/data/models/product_model.dart';
import 'package:flutter/material.dart';

class LowStockPreview extends StatelessWidget {
  final List<Product> products;

  const LowStockPreview({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lowStockProducts = products.where((p) => p.isLowStock).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Low Stock Alerts",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),

        if (lowStockProducts.isEmpty)
          const EntryAnimate(
            child: EmptyState(
              title: "All Items Are In Stock",
              subTitle:
                  "Products will appear here once it crosses low stock threshold.",
              icon: Icons.warning,
            ),
          ),
        if (lowStockProducts.isNotEmpty)
          ...lowStockProducts.map(
            (p) => Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? Colors.pink.withOpacity(0.08)
                        : Colors.red.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.red.withOpacity(0.35)),
              ),
              child: Row(
                children: [
                  // Left indicator
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? Colors.pink.withOpacity(0.15)
                              : Colors.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      size: 18,
                      color: isDark ? Colors.pink : Colors.red,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Product name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Below minimum stock level",
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.pink : Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Quantity
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? Colors.pink.withOpacity(0.12)
                              : Colors.red.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${p.quantity} left",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.pink : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
