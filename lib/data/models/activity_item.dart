enum ActivityType { sale, bargainSale, restock, lowStock }

class ActivityItem {
  final ActivityType type;
  final String title;
  final String subtitle;
  final String time;

  ActivityItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.time,
  });
}
