String timeAgo(String iso) {
  final dt = DateTime.parse(iso);
  final diff = DateTime.now().difference(dt);

  if (diff.inMinutes < 1) return "Just now";
  if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
  if (diff.inHours < 24) return "${diff.inHours} hr ago";
  return "${diff.inDays} day ago";
}

String formatDateHeader(String date) {
  final dt = DateTime.parse(date);
  final now = DateTime.now();

  if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
    return "Today";
  }

  return "${dt.day.toString().padLeft(2, '0')} "
      "${_monthName(dt.month)} ${dt.year}";
}

String _monthName(int month) {
  const months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];
  return months[month - 1];
}
