import 'package:blushly/screens/sales/providers/filtered_sales_product_provider.dart';
import 'package:blushly/screens/sales/providers/sales_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductSearchSheet extends ConsumerWidget {
  const ProductSearchSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(filteredSalesProductProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            height: 5,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Search product...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) {
                ref.read(salesSearchProvider.notifier).state = val;
              },
            ),
          ),
          Expanded(
            child: productsAsync.when(
              data:
                  (products) => ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (_, i) {
                      final p = products[i];
                      return ListTile(
                        title: Text(p.name),
                        subtitle: Text("Stock: ${p.quantity}"),
                        trailing: Text("₹${p.sellingPrice}"),
                        onTap: () {
                          Navigator.pop(context, p);
                        },
                      );
                    },
                  ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: $e")),
            ),
          ),
        ],
      ),
    );
  }
}
