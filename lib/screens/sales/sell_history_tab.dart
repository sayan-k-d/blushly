import 'package:blushly/core/utils/time_ago.dart';
import 'package:blushly/screens/sales/widgets/date_divider.dart';
import 'package:blushly/screens/sales/widgets/filter_bar.dart';
import 'package:blushly/screens/sales/widgets/sale_history_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/sell_history_provider.dart';

class SellHistoryTab extends ConsumerWidget {
  final void Function(WidgetRef) onRefresh;
  final WidgetRef wgRef;
  const SellHistoryTab({
    super.key,
    required this.onRefresh,
    required this.wgRef,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(sellHistoryProvider);
    Future<void> _onRefresh() async {
      // Re-fetch latest dues
      ref.invalidate(sellHistoryProvider);
      onRefresh(wgRef);

      // Small delay so refresh animation feels natural
      await Future.delayed(const Duration(milliseconds: 300));
    }

    return Column(
      children: [
        FilterBar(),

        Expanded(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: historyAsync.when(
              data:
                  (sales) =>
                      sales.isEmpty
                          ? const Center(child: Text("No sales found"))
                          : ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: sales.length,
                            itemBuilder: (_, i) {
                              final current = sales[i];
                              final currentDate =
                                  current['sale_date'] as String;

                              String? previousDate;
                              if (i > 0) {
                                previousDate =
                                    sales[i - 1]['sale_date'] as String;
                              }

                              final showDateHeader =
                                  i == 0 || currentDate != previousDate;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (showDateHeader)
                                    DateDivider(
                                      label: formatDateHeader(currentDate),
                                    ),

                                  SaleHistoryCard(data: current),
                                ],
                              );
                            },
                          ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: $e")),
            ),
          ),
        ),
      ],
    );
  }
}
