import 'package:flutter/material.dart';

class StockStatusChip extends StatelessWidget {
  final int quantity;
  final int threshold;

  const StockStatusChip({
    super.key,
    required this.quantity,
    required this.threshold,
  });

  @override
  Widget build(BuildContext context) {
    final isLow = quantity <= threshold;

    return Chip(
      label: Text(
        isLow ? "Restock" : "In Stock",
        style: TextStyle(
          color: isLow ? Colors.red : Colors.green,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      backgroundColor:
          isLow ? Colors.red.withOpacity(0.15) : Colors.green.withOpacity(0.15),
      avatar: Icon(
        isLow ? Icons.warning : Icons.check_circle,
        size: 16,
        color: isLow ? Colors.red : Colors.green,
      ),
    );
  }
}
