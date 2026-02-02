import 'package:blushly/data/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductSearchSelect extends StatefulWidget {
  final List<Product> products;
  final Function(Product) onSelected;

  const ProductSearchSelect({required this.products, required this.onSelected});

  @override
  State<ProductSearchSelect> createState() => _ProductSearchSheetState();
}

class _ProductSearchSheetState extends State<ProductSearchSelect> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    final filtered =
        widget.products
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: "Search product",
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (v) => setState(() => query = v),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final product = filtered[i];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text("Stock: ${product.quantity}"),
                  onTap: () => widget.onSelected(product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
