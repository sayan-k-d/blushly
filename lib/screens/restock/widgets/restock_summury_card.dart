import 'package:blushly/screens/restock/restock_history_detail_sheet.dart';
import 'package:flutter/material.dart';

class RestockSummaryCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const RestockSummaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder:
              (_) => RestockHistoryDetailSheet(
                productId: data['product_id'],
                productName: data['product_name'],
              ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['product_name'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 6),

            Text(
              "Restocked ${data['restock_count']} times this month",
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),

            const Divider(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Qty: ${data['total_quantity']}"),
                Text(
                  "₹${data['total_amount']}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              "Last restock: ${_formatDate(data['last_restock_at'])}",
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    final dt = DateTime.parse(iso);
    return "${dt.day}/${dt.month}/${dt.year}";
  }
}
