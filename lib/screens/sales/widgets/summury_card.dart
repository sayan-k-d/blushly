import 'package:blushly/data/models/product_model.dart';
import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final Product product;
  final int quantity;
  final double? overriddenSellingPrice;

  const SummaryCard({
    super.key,
    required this.product,
    required this.quantity,
    this.overriddenSellingPrice,
  });

  @override
  Widget build(BuildContext context) {
    final total = (overriddenSellingPrice ?? product.sellingPrice) * quantity;
    final profit =
        ((overriddenSellingPrice ?? product.sellingPrice) -
            product.purchasePrice) *
        quantity;
    final estimatedProfit =
        (product.sellingPrice - product.purchasePrice) * quantity;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            profit >= estimatedProfit
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _row("Total", "₹$total"),
          if (overriddenSellingPrice != null)
            _row("Estimated Profit", "₹$estimatedProfit"),
          _row("Profit", "₹$profit"),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
