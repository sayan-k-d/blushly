import 'package:blushly/screens/due/widgets/no_payment_history.dart';
import 'package:blushly/screens/due/widgets/payment_history_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/due_history_provider.dart';

class DueHistoryDetailSheet extends ConsumerWidget {
  final int saleId;
  final String customerName;
  final String? customerPhone;

  const DueHistoryDetailSheet({
    super.key,
    required this.saleId,
    required this.customerName,
    this.customerPhone,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(dueHistoryProvider(saleId));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Payment History",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          Row(
            children: [
              Text(customerName, style: TextStyle(color: Colors.grey[700])),
              if (customerPhone != null) const SizedBox(width: 6),
              if (customerPhone != null)
                Icon(Icons.more_vert, color: Colors.grey[700]),
              if (customerPhone != null) const SizedBox(width: 6),
              if (customerPhone != null)
                Text(customerPhone!, style: TextStyle(color: Colors.grey[700])),
            ],
          ),

          const SizedBox(height: 16),

          // Content
          historyAsync.when(
            loading:
                () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                ),
            error: (e, _) => Center(child: Text("Error: $e")),
            data: (history) {
              if (history.isEmpty) {
                return Center(child: const NoPaymentHistory());
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: history.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) => PaymentHistoryTile(data: history[i]),
              );
            },
          ),
        ],
      ),
    );
  }
}
