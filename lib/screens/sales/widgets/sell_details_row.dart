import 'package:flutter/material.dart';

class SaleDetailRow extends StatelessWidget {
  final int quantity;
  final double price;
  final double total;
  final double profit;
  final String time;
  final bool isOverridden;
  final bool isDue;
  final double dueAmount;

  const SaleDetailRow({
    super.key,
    required this.quantity,
    required this.price,
    required this.total,
    required this.profit,
    required this.time,
    required this.isOverridden,
    required this.isDue,
    required this.dueAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Qty + Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Qty: $quantity",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  if (isDue)
                    Text(
                      "(Due: ₹$dueAmount)",
                      style: const TextStyle(fontSize: 12, color: Colors.red),
                    ),
                ],
              ),

              Row(
                children: [
                  if (isOverridden)
                    Tooltip(
                      message: "Price adjusted for this sale",
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.price_change,
                          size: 14,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  if (isDue)
                    Tooltip(
                      message: "Price Due",
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.schedule,
                          size: 14,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  Text(
                    "₹$total",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Price + Profit + Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Price: ₹$price",
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
              Text(
                "Profit: ₹$profit",
                style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
              Text(
                _formatTime(time),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(String iso) {
    final dt = DateTime.parse(iso);
    return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }
}
