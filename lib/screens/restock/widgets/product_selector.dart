import 'package:blushly/data/models/product_model.dart';
import 'package:blushly/screens/products/providers/product_provider.dart';
import 'package:blushly/screens/restock/widgets/product_search_select.dart';
import 'package:blushly/screens/sales/widgets/product_search_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductSelector extends ConsumerWidget {
  final Product? selectedProduct;
  final Function(Product) onSelected;

  const ProductSelector({
    super.key,
    required this.onSelected,
    this.selectedProduct,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);

    return productsAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text("Error: $e"),
      data: (products) {
        return InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder:
                  (_) => ProductSearchSelect(
                    products: products,
                    onSelected: (p) {
                      Navigator.pop(context);
                      onSelected(p);
                    },
                  ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    selectedProduct == null
                        ? Colors.grey.shade400
                        : Theme.of(context).colorScheme.primary,
              ),
              color:
                  selectedProduct == null
                      ? Colors.transparent
                      : Theme.of(context).colorScheme.primary.withOpacity(0.06),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color:
                      selectedProduct == null
                          ? Colors.grey
                          : Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    selectedProduct?.name ?? "Search & select product",
                    style: TextStyle(
                      color:
                          selectedProduct == null ? Colors.grey : Colors.black,
                      fontWeight:
                          selectedProduct == null
                              ? FontWeight.normal
                              : FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                if (selectedProduct != null)
                  const Icon(Icons.check_circle, color: Colors.green, size: 18),
              ],
            ),
          ),
        );
      },
    );
  }
}
