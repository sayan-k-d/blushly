import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String? subTitle;
  final IconData icon;

  const EmptyState({
    super.key,
    required this.title,
    required this.icon,
    this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // ≈ 2 list tiles
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon container
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.pink.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.pink, size: 24),
          ),

          const SizedBox(width: 16),

          // Text
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                if (subTitle != null) SizedBox(height: 4),
                if (subTitle != null)
                  Text(
                    subTitle!,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
