import 'package:blushly/screens/restock/widgets/restock_summury_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/restock_history_provider.dart';

class RestockHistoryTab extends ConsumerWidget {
  const RestockHistoryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(restockHistoryProvider);

    return historyAsync.when(
      data:
          (items) =>
              items.isEmpty
                  ? const Center(child: Text("No restocks this month"))
                  : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final data = items[i];
                      return RestockSummaryCard(data: data);
                    },
                  ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
    );
  }
}
