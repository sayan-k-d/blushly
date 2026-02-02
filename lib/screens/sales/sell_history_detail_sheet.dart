import 'package:blushly/screens/sales/widgets/sell_details_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/sell_history_detail_provider.dart';

class SellHistoryDetailSheet extends ConsumerWidget {
  final int productId;
  final String productName;
  final String saleDate; // yyyy-MM-dd

  const SellHistoryDetailSheet({
    super.key,
    required this.productId,
    required this.productName,
    required this.saleDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSales = ref.watch(
      sellHistoryDetailProvider((productId: productId, saleDate: saleDate)),
    );

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  height: 5,
                  width: 40,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Header
              Text(
                productName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Sales on $saleDate",
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),

              const SizedBox(height: 16),

              // ✅ ASYNC CONTENT — THIS IS THE KEY
              Expanded(
                child: asyncSales.when(
                  loading:
                      () => const Center(child: CircularProgressIndicator()),

                  error: (e, _) => Center(child: Text("Error: $e")),

                  data: (items) {
                    if (items.isEmpty) {
                      return const Center(child: Text("No sales found"));
                    }

                    return ListView.separated(
                      controller: controller,
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final s = items[i];
                        final qty = s['quantity'];
                        final price = s['selling_price'];
                        final total = qty * price;
                        final profit = s['profit'];
                        final isOverride = s['is_price_overridden'] == 1;
                        final isDue = s['is_due'] == 1;
                        final dueAmt = s['due_amount'];

                        return SaleDetailRow(
                          quantity: qty,
                          price: price,
                          total: total,
                          profit: profit,
                          time: s['created_at'],
                          isOverridden: isOverride,
                          isDue: isDue,
                          dueAmount: dueAmt,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
