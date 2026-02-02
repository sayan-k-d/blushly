import 'package:blushly/screens/sales/providers/sales_search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../products/providers/product_provider.dart';

final filteredSalesProductProvider = Provider((ref) {
  final productsAsync = ref.watch(productListProvider);
  final search = ref.watch(salesSearchProvider).toLowerCase();

  return productsAsync.whenData((products) {
    return products.where((p) {
      return p.name.toLowerCase().contains(search) && p.quantity > 0;
    }).toList();
  });
});
