import 'package:blushly/core/widgets/empty_state.dart';
import 'package:blushly/screens/products/widgets/low_stock_banner.dart';
import 'package:blushly/screens/products/widgets/low_stock_card.dart';
import 'package:blushly/screens/products/widgets/low_stock_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product_model.dart';
import '../products/providers/product_provider.dart';

class LowStockProductsScreen extends ConsumerWidget {
  const LowStockProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Low Stock"), centerTitle: false),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (products) {
          final lowStockProducts =
              products.where((p) => p.quantity <= p.lowStockThreshold).toList();

          if (lowStockProducts.isEmpty) {
            return const LowStockEmptyState();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header summary
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  "${lowStockProducts.length} products need restocking",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),

              // 🔹 Info banner
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: LowStockInfoBanner(),
              ),

              const SizedBox(height: 8),

              // 🔹 List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: lowStockProducts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final product = lowStockProducts[i];
                    return LowStockCard(product: product);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
