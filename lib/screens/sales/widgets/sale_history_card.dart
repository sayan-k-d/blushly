import 'package:blushly/screens/sales/sell_history_detail_sheet.dart';
import 'package:flutter/material.dart';

class SaleHistoryCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const SaleHistoryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final qty = data['total_quantity'];
    final total = data['total_amount'];
    final profit = data['total_profit'];
    final lastTime = DateTime.parse(data['last_sold_at']);
    final date = data['sale_date'];

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder:
              (_) => SellHistoryDetailSheet(
                productId: data['product_id'],
                productName: data['product_name'],
                saleDate: data['sale_date'], // yyyy-MM-dd
              ),
        );
      },

      child: Card(
        elevation: 1,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product name
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        data['product_name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      if (data['is_price_overridden'] == 1)
                        const SizedBox(width: 6),
                      if (data['is_price_overridden'] == 1)
                        Tooltip(
                          message: "Price adjusted for this sale",
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.price_change,
                              size: 16,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      if (data['is_due'] == 1) const SizedBox(width: 6),
                      if (data['is_due'] == 1)
                        Tooltip(
                          message: "Due amount: ₹${data['due_amount']}",
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.schedule,
                              size: 16,
                              color: Colors.red,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Purchase Price: ",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      Text(
                        '₹${data['purchase_price'].toString()}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // Category + Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${data['category_name'] ?? 'Uncategorized'} • $date",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  Row(
                    children: [
                      Text(
                        "Selling Price: ",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      Text(
                        '₹${data['selling_price'].toString()}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),

              const Divider(height: 18),

              // Quantity & Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Total Qty: $qty"), Text("Total: ₹$total")],
              ),

              const SizedBox(height: 6),

              // Profit & Last sold time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Profit: ₹$profit",
                    style: const TextStyle(color: Colors.green),
                  ),
                  Text(
                    "Last sold at ${_formatTime(lastTime)}",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }
}
// class SaleHistoryCard extends StatelessWidget {
//   final Map<String, dynamic> data;

//   const SaleHistoryCard({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     final total = (data['selling_price'] as num) * data['quantity'];
//     final profit = data['profit'];

//     return Card(
//       elevation: 1,
//       margin: const EdgeInsets.only(bottom: 10),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(14),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               data['product_name'],
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),

//             const SizedBox(height: 4),

//             Text(
//               data['category_name'] ?? "Uncategorized",
//               style: TextStyle(color: Colors.grey[600], fontSize: 12),
//             ),

//             const Divider(height: 16),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Qty: ${data['quantity']}"),
//                 Text("Total: ₹$total"),
//               ],
//             ),

//             const SizedBox(height: 4),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Profit: ₹$profit",
//                   style: const TextStyle(color: Colors.green),
//                 ),
//                 Text(
//                   _formatTime(data['created_at']),
//                   style: TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatTime(String iso) {
//     final dt = DateTime.parse(iso);
//     return "${dt.day}/${dt.month}/${dt.year}  ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
//   }
// }
