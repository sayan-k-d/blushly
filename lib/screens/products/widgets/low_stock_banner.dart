import 'package:flutter/material.dart';

class LowStockInfoBanner extends StatelessWidget {
  const LowStockInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_outline, color: Colors.blue),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Products listed here are below or near their minimum stock level.",
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
