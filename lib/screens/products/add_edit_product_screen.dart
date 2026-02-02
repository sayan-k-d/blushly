import 'package:blushly/screens/categories/providers/category_provider.dart';
import 'package:blushly/screens/dashboard/providers/dashboard_provider.dart';
import 'package:blushly/screens/restock/providers/restock_history_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product_model.dart';
import 'providers/product_provider.dart';

class AddEditProductScreen extends ConsumerStatefulWidget {
  final Product? product;

  const AddEditProductScreen({super.key, this.product});

  @override
  ConsumerState<AddEditProductScreen> createState() =>
      _AddEditProductScreenState();
}

class _AddEditProductScreenState extends ConsumerState<AddEditProductScreen> {
  final _nameController = TextEditingController();
  final _purchaseController = TextEditingController();
  final _sellingController = TextEditingController();
  final _quantityController = TextEditingController();
  final _thresholdController = TextEditingController();

  int? _selectedCategory;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    if (p != null) {
      _nameController.text = p.name;
      _purchaseController.text = p.purchasePrice.toString();
      _sellingController.text = p.sellingPrice.toString();
      _quantityController.text = p.quantity.toString();
      _thresholdController.text = p.lowStockThreshold.toString();
      _selectedCategory = p.categoryId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? "Add Product" : "Edit Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Product Name"),
            ),
            const SizedBox(height: 12),

            categoriesAsync.when(
              data:
                  (categories) => DropdownButtonFormField<int>(
                    value: _selectedCategory,
                    hint: const Text("Select Category"),
                    items:
                        categories
                            .map(
                              (c) => DropdownMenuItem(
                                value: c.id,
                                child: Text(c.name),
                              ),
                            )
                            .toList(),
                    onChanged: (val) => _selectedCategory = val,
                  ),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text("Error: $e"),
            ),

            const SizedBox(height: 12),
            TextField(
              controller: _purchaseController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Purchase Price"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _sellingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Selling Price"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Quantity"),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _thresholdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Low Stock Threshold",
                hintText: "e.g. 5",
              ),
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (_selectedCategory == null) return;

                final repo = ref.read(productRepositoryProvider);

                final product = Product(
                  id: widget.product?.id,
                  name: _nameController.text.trim(),
                  categoryId: _selectedCategory!,
                  purchasePrice: double.parse(_purchaseController.text),
                  sellingPrice: double.parse(_sellingController.text),
                  quantity: int.parse(_quantityController.text),
                  lowStockThreshold:
                      int.tryParse(_thresholdController.text) ?? 5,
                  createdAt:
                      widget.product?.createdAt ??
                      DateTime.now().toIso8601String(),
                );

                if (widget.product == null) {
                  await repo.addProduct(product);
                } else {
                  await repo.updateProduct(product);
                }

                ref.invalidate(productListProvider);
                ref.invalidate(dashboardProvider);
                ref.invalidate(restockHistoryProvider);
                Navigator.pop(context);
              },
              child: const Text("Save Product"),
            ),
          ],
        ),
      ),
    );
  }
}
