import 'package:flutter/material.dart';

class LowStockEmptyState extends StatelessWidget {
  const LowStockEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.check_circle_outline,
              size: 32,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "All stocks are healthy",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            "No products need restocking right now.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
