import 'package:blushly/core/widgets/empty_state.dart';
import 'package:blushly/core/widgets/entry_animate.dart';
import 'package:blushly/data/models/activity_item.dart';
import 'package:blushly/screens/dashboard/widgets/recent_activity_row.dart';
import 'package:flutter/material.dart';

class RecentActivitySection extends StatelessWidget {
  final List<ActivityItem> activities;

  const RecentActivitySection({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (activities.isEmpty)
          const EntryAnimate(
            child: EmptyState(
              title: "No recent activity",
              subTitle:
                  "Sales and restocks will appear here once activity starts.",
              icon: Icons.event_note,
            ),
          ),

        ...activities.map((a) => RecentActivityRow(item: a)),
      ],
    );
  }
}
