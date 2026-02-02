import 'package:blushly/data/models/product_model.dart';
import 'package:blushly/screens/dashboard/providers/dashboard_provider.dart';
import 'package:blushly/screens/dashboard/providers/recent_activity_provider.dart';
import 'package:blushly/screens/products/providers/product_provider.dart';
import 'package:blushly/screens/restock/providers/restock_history_provider.dart';
import 'package:blushly/screens/restock/widgets/product_search_select.dart';
import 'package:blushly/screens/restock/widgets/product_selector.dart';
import 'package:blushly/screens/sales/widgets/product_search_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/restock_provider.dart';

class RestockSheet extends ConsumerStatefulWidget {
  final Product? product;

  const RestockSheet({super.key, this.product});

  @override
  ConsumerState<RestockSheet> createState() => _RestockSheetState();
}

class _RestockSheetState extends ConsumerState<RestockSheet> {
  final qtyController = TextEditingController();
  final priceController = TextEditingController();
  Product? selectedProduct;
  @override
  void initState() {
    super.initState();
    selectedProduct = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Restock ${selectedProduct?.name ?? "Product"}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),
          if (widget.product == null)
            ProductSelector(
              selectedProduct: selectedProduct,
              onSelected: (product) {
                setState(() {
                  selectedProduct = product;
                });
              },
            ),
          const SizedBox(height: 12),

          TextField(
            controller: qtyController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Quantity to add"),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Purchase price (optional)",
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () async {
                final qty = int.tryParse(qtyController.text) ?? 0;
                if (qty <= 0) return;

                final enteredPrice = double.tryParse(priceController.text);

                // ✅ FALLBACK LOGIC
                final product = selectedProduct;
                if (product == null) return;
                final effectivePurchasePrice =
                    enteredPrice ?? product.purchasePrice;

                await ref
                    .read(restockRepositoryProvider)
                    .restockProduct(
                      productId: product.id!,
                      quantity: qty,
                      purchasePrice: effectivePurchasePrice,
                    );

                ref.invalidate(productListProvider);
                ref.invalidate(dashboardProvider);
                ref.invalidate(restockHistoryProvider);
                ref.invalidate(recentActivityProvider);

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Stock updated successfully")),
                );
              },
              child: const Text("CONFIRM RESTOCK"),
            ),
          ),
        ],
      ),
    );
  }
}
