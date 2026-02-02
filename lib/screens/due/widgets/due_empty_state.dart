import 'package:flutter/material.dart';

class DueEmptyState extends StatelessWidget {
  const DueEmptyState({super.key});

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
              Icons.check_circle,
              color: Colors.green,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "No pending dues",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Text(
            "All customer payments are settled.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
