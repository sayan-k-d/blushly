import 'package:blushly/data/models/product_model.dart';
import 'package:blushly/screens/dashboard/providers/dashboard_provider.dart';
import 'package:blushly/screens/dashboard/providers/recent_activity_provider.dart';
import 'package:blushly/screens/due/providers/due_history_provider.dart';
import 'package:blushly/screens/due/providers/due_list_provider.dart';
import 'package:blushly/screens/due/providers/due_repository_provider.dart';
import 'package:blushly/screens/products/providers/product_provider.dart';
import 'package:blushly/screens/sales/providers/quick_sell_reset_provider.dart';
import 'package:blushly/screens/sales/providers/sell_history_detail_provider.dart';
import 'package:blushly/screens/sales/providers/sell_history_provider.dart';
import 'package:blushly/screens/sales/widgets/product_search_sheet.dart';
import 'package:blushly/screens/sales/widgets/quantity_stepper.dart';
import 'package:blushly/screens/sales/widgets/summury_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/sales_provider.dart';
import 'providers/sales_search_provider.dart';
import 'widgets/product_preview.dart';

class QuickSellTab extends ConsumerStatefulWidget {
  final bool isTab;
  const QuickSellTab({super.key, this.isTab = true});

  @override
  ConsumerState<QuickSellTab> createState() => _QuickSellTabState();
}

class _QuickSellTabState extends ConsumerState<QuickSellTab> {
  Product? selectedProduct;
  bool isDue = false;
  int quantity = 1;
  double? ovrSellingPrice;
  String? qtyError;
  String? ovrSellingError;
  final qtyController = TextEditingController(text: "1");
  final priceController = TextEditingController();
  String? customerName;
  String? customerPhone;
  double dueAmount = 0;

  void _clearAll() {
    setState(() {
      selectedProduct = null;
      quantity = 1;
      ovrSellingPrice = null;
      qtyError = null;
      ovrSellingError = null;
      qtyController.text = "1";
      priceController.text = "";
      isDue = false;
      customerName = null;
      customerPhone = null;
      dueAmount = 0;
    });

    ref.read(salesSearchProvider.notifier).state = '';

    // ScaffoldMessenger.of(
    //   context,
    // ).showSnackBar(const SnackBar(content: Text("Quick Sell cleared")));
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(quickSellResetProvider, (_, __) {
      _clearAll();
    });
    return Scaffold(
      appBar:
          widget.isTab
              ? null
              : AppBar(title: const Text("Quick Sell"), centerTitle: false),
      // appBar: AppBar(automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔥 SCROLLABLE CONTENT
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _openProductSearch(context),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.pink.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                selectedProduct?.name ??
                                    "Search & select product",
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      selectedProduct == null
                                          ? Colors.grey
                                          : Colors.black,
                                ),
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    if (selectedProduct != null)
                      ProductPreview(product: selectedProduct!),

                    const SizedBox(height: 16),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (selectedProduct != null)
                          Expanded(
                            child: TextField(
                              controller: qtyController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Quantity",
                                errorText: qtyError,
                              ),
                              onChanged: (val) {
                                final qty = int.tryParse(val) ?? 0;
                                if (qty > selectedProduct!.quantity) {
                                  setState(() {
                                    qtyError =
                                        "Only ${selectedProduct!.quantity} in stock";
                                  });
                                } else {
                                  setState(() {
                                    quantity = qty;
                                    qtyError = null;
                                  });
                                }
                              },
                            ),
                          ),
                        SizedBox(width: 16),
                        if (selectedProduct != null)
                          Expanded(
                            child: TextField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Selling Price (optional)",
                                helperText: "Leave empty for default price",
                                errorText: ovrSellingError,
                              ),
                              onChanged: (val) {
                                final finalOvrSellingPrice =
                                    double.tryParse(val) ?? 0;
                                if (finalOvrSellingPrice < 0) {
                                  setState(() {
                                    ovrSellingPrice = null;
                                    ovrSellingError =
                                        "Overridden price cannot be negative";
                                  });
                                  return;
                                } else if (finalOvrSellingPrice >
                                    selectedProduct!.sellingPrice) {
                                  setState(() {
                                    ovrSellingPrice =
                                        finalOvrSellingPrice.toDouble();
                                    ovrSellingError =
                                        "Price cannot exceed default selling price of ₹${selectedProduct!.sellingPrice}";
                                  });
                                  return;
                                } else {
                                  setState(() {
                                    ovrSellingPrice = double.tryParse(val);
                                    ovrSellingError = null;
                                  });
                                }
                              },
                            ),
                          ),
                      ],
                    ),

                    // QuantityStepper(
                    //   quantity: quantity,
                    //   max: selectedProduct!.quantity,
                    //   onChanged: (val) => setState(() => quantity = val),
                    // ),
                    // const SizedBox(height: 16),
                    // Text(
                    //   "Estimated Profit: ₹${estimatedProfit.toStringAsFixed(2)}",
                    //   style: const TextStyle(fontWeight: FontWeight.w600),
                    // ),
                    const SizedBox(height: 16),

                    if (selectedProduct != null)
                      SummaryCard(
                        overriddenSellingPrice: ovrSellingPrice,
                        product: selectedProduct!,
                        quantity: quantity,
                      ),

                    const SizedBox(height: 16),
                    if (selectedProduct != null)
                      // Expanded(
                      //   child:
                      SwitchListTile(
                        title: const Text("Mark as due"),
                        subtitle: const Text("Customer will pay later"),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        value: isDue,
                        onChanged: (v) => setState(() => isDue = v),
                      ),

                    // ),
                    if (selectedProduct != null && isDue) ...[
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: "Customer name *",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (v) => customerName = v,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Due amount *",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (v) => dueAmount = double.tryParse(v) ?? 0,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: "Phone (optional)",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (v) => customerPhone = v,
                        ),
                      ),
                    ],

                    const SizedBox(height: 24), // breathing room
                  ],
                ),
              ),
            ),

            // 🔒 FIXED BOTTOM BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed:
                    selectedProduct == null
                        ? null
                        : () async {
                          if (quantity <= 0 || qtyError != null) return;
                          final overriddenPrice = double.tryParse(
                            priceController.text,
                          );
                          final totalAmount =
                              (overriddenPrice ??
                                  selectedProduct!.sellingPrice) *
                              quantity;
                          if (isDue) {
                            if (customerName == null || customerName!.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Color(0xFFF9E9E9),
                                  content: Text(
                                    "Customer name is required for due sales",
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ),
                              );
                              return;
                            }
                            if (dueAmount <= 0 || dueAmount > totalAmount) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Color(0xFFF9E9E9),
                                  content: Text(
                                    "Due amount can not be More than total Price",
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ),
                              );
                              return;
                            }
                          }
                          await ref
                              .read(salesRepositoryProvider)
                              .makeSale(
                                productId: selectedProduct!.id!,
                                quantity: quantity,
                                sellingPrice: selectedProduct!.sellingPrice,
                                purchasePrice: selectedProduct!.purchasePrice,
                                overriddenSellingPrice: overriddenPrice,

                                isDue: isDue,
                                dueAmount: dueAmount,
                                customerName: customerName,
                                customerPhone: customerPhone,
                              );

                          ref.invalidate(productListProvider);
                          ref.invalidate(dashboardProvider);
                          ref.invalidate(sellHistoryProvider);
                          ref.invalidate(sellHistoryDetailProvider);
                          ref.invalidate(recentActivityProvider);
                          ref.invalidate(dueListProvider);
                          ref.invalidate(dueHistoryProvider);
                          ref.invalidate(dueRepositoryProvider);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Successfully Sold 🎉"),
                            ),
                          );
                          _clearAll();
                          setState(() => selectedProduct = null);
                        },
                child: const Text(
                  "CONFIRM SALE",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openProductSearch(BuildContext context) async {
    final product = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const ProductSearchSheet(),
    );

    if (product != null) {
      setState(() {
        selectedProduct = product;
        quantity = 1;
      });
    }
  }

  double get effectivePrice {
    return double.tryParse(priceController.text) ??
        selectedProduct!.sellingPrice;
  }

  double get estimatedProfit {
    final qty = int.tryParse(qtyController.text) ?? 0;
    return (effectivePrice - selectedProduct!.purchasePrice) * qty;
  }
}
