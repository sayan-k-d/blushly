import 'package:blushly/screens/categories/providers/category_provider.dart';
import 'package:blushly/screens/sales/providers/sell_history_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterBar extends ConsumerWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryListProvider);
    final filter = ref.watch(saleFilterProvider);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Search
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search product",
                  ),
                  onChanged:
                      (val) =>
                          ref.read(sellHistorySearchProvider.notifier).state =
                              val,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<SaleFilter>(
                  initialValue: filter,
                  items: const [
                    DropdownMenuItem(
                      value: SaleFilter.all,
                      child: Text("All sales"),
                    ),
                    DropdownMenuItem(
                      value: SaleFilter.dueOnly,
                      child: Text("Due only"),
                    ),
                  ],
                  onChanged:
                      (v) => ref.read(saleFilterProvider.notifier).state = v!,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              // Date Filter
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.date_range),
                  label: const Text("Date Range"),
                  onPressed: () async {
                    final range = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      saveText: "Apply",
                    );
                    debugPrint("Selected range: $range");
                    if (range != null) {
                      ref.read(sellHistoryDateRangeProvider.notifier).state =
                          range;
                    }
                  },
                ),
              ),

              const SizedBox(width: 8),

              // Category Filter
              Expanded(
                child: categoriesAsync.when(
                  data:
                      (categories) => DropdownButtonFormField<int?>(
                        hint: const Text("Category"),
                        value: ref.watch(sellHistoryCategoryProvider),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text("All"),
                          ),
                          ...categories.map(
                            (c) => DropdownMenuItem(
                              value: c.id,
                              child: Text(c.name),
                            ),
                          ),
                        ],
                        onChanged:
                            (val) =>
                                ref
                                    .read(sellHistoryCategoryProvider.notifier)
                                    .state = val,
                      ),
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
