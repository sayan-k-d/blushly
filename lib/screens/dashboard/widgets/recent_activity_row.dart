import 'package:blushly/data/models/activity_item.dart';
import 'package:flutter/material.dart';

class RecentActivityRow extends StatelessWidget {
  final ActivityItem item;

  const RecentActivityRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final config = _activityConfig(item.type);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Icon
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: config.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(config.icon, color: config.color, size: 20),
          ),

          const SizedBox(width: 12),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Time
          Text(
            item.time,
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

({IconData icon, Color color}) _activityConfig(ActivityType type) {
  switch (type) {
    case ActivityType.sale:
      return (icon: Icons.shopping_cart, color: Colors.green);
    case ActivityType.bargainSale:
      return (icon: Icons.price_change, color: Colors.orange);
    case ActivityType.restock:
      return (icon: Icons.add_box, color: Colors.blue);
    case ActivityType.lowStock:
      return (icon: Icons.warning, color: Colors.red);
  }
}
