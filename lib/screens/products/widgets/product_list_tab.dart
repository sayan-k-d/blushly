import 'package:blushly/core/widgets/stock_status_chip.dart';
import 'package:blushly/screens/categories/providers/category_provider.dart';
import 'package:blushly/screens/dashboard/providers/dashboard_provider.dart';
import 'package:blushly/screens/products/action_icon.dart';
import 'package:blushly/screens/products/add_edit_product_screen.dart';
import 'package:blushly/screens/products/providers/filtered_product_provider.dart';
import 'package:blushly/screens/products/providers/product_filter_provider.dart';
import 'package:blushly/screens/products/providers/product_provider.dart';
import 'package:blushly/screens/restock/providers/restock_history_provider.dart';
import 'package:blushly/screens/restock/restock_sheet.dart';
import 'package:blushly/screens/sales/providers/sell_history_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductListTab extends ConsumerWidget {
  const ProductListTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(filteredProductListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // appBar: AppBar(title: const Text("Products"), centerTitle: false),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_product_btn',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditProductScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onChanged: (value) {
                ref.read(productSearchProvider.notifier).state = value;
              },
            ),
          ),

          // Category Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Consumer(
              builder: (_, ref, __) {
                final categoriesAsync = ref.watch(categoryListProvider);
                final selected = ref.watch(productCategoryFilterProvider);

                return categoriesAsync.when(
                  data:
                      (categories) => DropdownButtonFormField<int?>(
                        value: selected,
                        hint: const Text("Filter by Category"),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text("All Categories"),
                          ),
                          ...categories.map(
                            (c) => DropdownMenuItem(
                              value: c.id,
                              child: Text(c.name),
                            ),
                          ),
                        ],
                        onChanged: (val) {
                          ref
                              .read(productCategoryFilterProvider.notifier)
                              .state = val;
                        },
                      ),
                  loading: () => const SizedBox(),
                  error: (e, _) => Text("Error: $e"),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: productsAsync.when(
              data:
                  (products) => ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: products.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final product = products[i];

                      return Container(
                        decoration: BoxDecoration(
                          // color: Colors.white,
                          color: Theme.of(context).colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // 🧴 Product Icon
                              Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  color: Colors.pink.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        isDark
                                            ? Color(0xFF713240)
                                            : Colors.transparent,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.shopping_bag,
                                  color: Colors.pink,
                                ),
                              ),

                              const SizedBox(width: 14),

                              // 📦 Product Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Row(
                                      children: [
                                        Text(
                                          "Qty: ${product.quantity}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          "₹${product.sellingPrice}",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 10),

                              // 🟢 Status + Actions
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  StockStatusChip(
                                    quantity: product.quantity,
                                    threshold: product.lowStockThreshold,
                                  ),

                                  const SizedBox(height: 6),

                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ActionIcon(
                                        icon: Icons.edit,
                                        color: Colors.blueGrey,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => AddEditProductScreen(
                                                    product: product,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 6),
                                      ActionIcon(
                                        icon: Icons.delete,
                                        color: Colors.red,
                                        onTap: () async {
                                          await ref
                                              .read(productRepositoryProvider)
                                              .deleteProduct(product.id!);

                                          ref.invalidate(productListProvider);
                                          ref.invalidate(dashboardProvider);
                                          ref.invalidate(sellHistoryProvider);
                                          ref.invalidate(
                                            restockHistoryProvider,
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 6),
                                      ActionIcon(
                                        icon: Icons.add_box,
                                        color: Colors.green,
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                    top: Radius.circular(24),
                                                  ),
                                            ),
                                            builder:
                                                (_) => RestockSheet(
                                                  product: product,
                                                ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
