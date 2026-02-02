import 'package:blushly/screens/due/providers/due_history_provider.dart';
import 'package:blushly/screens/due/providers/due_list_provider.dart';
import 'package:blushly/screens/due/providers/due_repository_provider.dart';
import 'package:blushly/screens/sales/providers/sell_history_detail_provider.dart';
import 'package:blushly/screens/sales/providers/sell_history_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DueClearanceSheet extends ConsumerStatefulWidget {
  final String customerName;
  final String? customerPhone;
  final double totalDue;

  const DueClearanceSheet({
    super.key,
    required this.customerName,
    this.customerPhone,
    required this.totalDue,
  });

  @override
  ConsumerState<DueClearanceSheet> createState() => _DueClearanceSheetState();
}

class _DueClearanceSheetState extends ConsumerState<DueClearanceSheet> {
  final amountController = TextEditingController();
  double? enteredAmount;
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Clear Due",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 6),

          Text(widget.customerName, style: TextStyle(color: Colors.grey[700])),

          const SizedBox(height: 12),

          Text(
            "Total Due: ₹${widget.totalDue}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Payment amount",
              errorText: errorText,
            ),
            onChanged: (val) {
              final parsed = double.tryParse(val);

              setState(() {
                enteredAmount = parsed;

                if (parsed == null || parsed <= 0) {
                  errorText = "Enter a valid amount";
                } else if (parsed > widget.totalDue) {
                  errorText = "Amount cannot exceed due of ₹${widget.totalDue}";
                } else {
                  errorText = null;
                }
              });
            },
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed:
                  (enteredAmount == null || errorText != null)
                      ? null
                      : () async {
                        await ref
                            .read(dueRepositoryProvider)
                            .recordPayment(
                              customerName: widget.customerName,
                              customerPhone: widget.customerPhone,
                              amountPaid: enteredAmount!,
                            );

                        ref.invalidate(dueListProvider);
                        ref.invalidate(dueHistoryProvider);
                        ref.invalidate(dueRepositoryProvider);
                        ref.invalidate(sellHistoryProvider);
                        ref.invalidate(sellHistoryDetailProvider);
                        Navigator.pop(context);
                      },
              child: const Text("CONFIRM PAYMENT"),
            ),
          ),
        ],
      ),
    );
  }
}
