import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/product_model.dart';
import 'product_provider.dart';
import 'product_filter_provider.dart';

final filteredProductListProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productListProvider);
  final search = ref.watch(productSearchProvider).toLowerCase();
  final categoryId = ref.watch(productCategoryFilterProvider);

  return productsAsync.whenData((products) {
    return products.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(search);

      final matchesCategory =
          categoryId == null || product.categoryId == categoryId;

      return matchesSearch && matchesCategory;
    }).toList();
  });
});
