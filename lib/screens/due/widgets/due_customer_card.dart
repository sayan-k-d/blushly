import 'package:blushly/screens/due/widgets/due_clearance_sheet.dart';
import 'package:blushly/screens/due/widgets/due_history_detail_sheet.dart';
import 'package:flutter/material.dart';

class DueCustomerCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const DueCustomerCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final amount = data['total_due'] as num;

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder:
              (_) => DueHistoryDetailSheet(
                saleId: data['id'],
                customerName: data['customer_name'],
                customerPhone: data['customer_phone'],
              ),
        );
      },

      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.person, color: Colors.red),
            ),

            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['customer_name'] ?? "Unknown",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (data['customer_phone'] != null)
                    Text(
                      data['customer_phone'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        data['product_name'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 120,
                        child: Text(
                          "${data['due_count']} pending payments",
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 12,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text("Total Due", style: TextStyle(fontSize: 11)),
                Text(
                  "₹${amount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.payments),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      builder:
                          (_) => DueClearanceSheet(
                            customerName: data['customer_name'],
                            customerPhone: data['customer_phone'],
                            totalDue: data['total_due'],
                          ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
