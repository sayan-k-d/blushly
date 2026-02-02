import 'package:blushly/screens/sales/providers/quick_sell_reset_provider.dart';
import 'package:blushly/screens/sales/providers/sell_history_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'quick_sell_tab.dart';
import 'sell_history_tab.dart';

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Rebuild AppBar when tab changes
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _clearSellHistoryFilters(WidgetRef ref) {
    ref.read(sellHistorySearchProvider.notifier).state = '';
    ref.read(sellHistoryCategoryProvider.notifier).state = null;
    ref.read(sellHistoryDateRangeProvider.notifier).state = null;
    ref.read(saleFilterProvider.notifier).state = SaleFilter.all;
  }

  @override
  Widget build(BuildContext context) {
    final isQuickSell = _tabController.index == 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(isQuickSell ? "Quick Sell" : "Sell History"),

        // ✅ CLEAR BUTTON ONLY FOR QUICK SELL
        actions: [
          IconButton(
            tooltip: isQuickSell ? "Clear Quick Sell" : "Clear Filters",
            icon: const Icon(Icons.cached),
            onPressed: () {
              if (isQuickSell) {
                // 🔄 Reset quick sell state
                ref.read(quickSellResetProvider.notifier).state++;
              } else {
                // 🔄 Clear sell history filters
                _clearSellHistoryFilters(ref);
              }
            },
          ),
        ],

        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: "Quick Sell"), Tab(text: "Sell History")],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          QuickSellTab(),
          SellHistoryTab(onRefresh: _clearSellHistoryFilters, wgRef: ref),
        ],
      ),
    );
  }
}

// import 'package:blushly/screens/dashboard/providers/dashboard_provider.dart';
// import 'package:blushly/screens/products/providers/product_provider.dart';
// import 'package:blushly/screens/sales/widgets/product_preview.dart';
// import 'package:blushly/screens/sales/widgets/product_search_sheet.dart';
// import 'package:blushly/screens/sales/widgets/quantity_stepper.dart';
// import 'package:blushly/screens/sales/widgets/summury_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../data/models/product_model.dart';
// import 'providers/sales_provider.dart';

// class SalesScreen extends ConsumerStatefulWidget {
//   const SalesScreen({super.key});

//   @override
//   ConsumerState<SalesScreen> createState() => _SalesScreenState();
// }

// class _SalesScreenState extends ConsumerState<SalesScreen> {
//   Product? selectedProduct;
//   int quantity = 1;

//   void _openProductSearch() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (_) => const ProductSearchSheet(),
//     ).then((product) {
//       if (product != null) {
//         setState(() {
//           selectedProduct = product;
//           quantity = 1;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Quick Sale")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Product Picker
//             GestureDetector(
//               onTap: _openProductSearch,
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.pink.withOpacity(0.08),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.search),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         selectedProduct?.name ?? "Search & select product",
//                         style: TextStyle(
//                           fontSize: 16,
//                           color:
//                               selectedProduct == null
//                                   ? Colors.grey
//                                   : Colors.black,
//                         ),
//                       ),
//                     ),
//                     const Icon(Icons.chevron_right),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Product Preview
//             if (selectedProduct != null)
//               ProductPreview(product: selectedProduct!),

//             const SizedBox(height: 16),

//             // Quantity Stepper
//             if (selectedProduct != null)
//               QuantityStepper(
//                 quantity: quantity,
//                 max: selectedProduct!.quantity,
//                 onChanged: (val) => setState(() => quantity = val),
//               ),

//             const SizedBox(height: 20),

//             // Summary
//             if (selectedProduct != null)
//               SummaryCard(product: selectedProduct!, quantity: quantity),

//             const Spacer(),

//             // Confirm Button
//             SizedBox(
//               width: double.infinity,
//               height: 52,
//               child: ElevatedButton(
//                 onPressed:
//                     selectedProduct == null
//                         ? null
//                         : () async {
//                           await ref
//                               .read(salesRepositoryProvider)
//                               .makeSale(
//                                 productId: selectedProduct!.id!,
//                                 quantity: quantity,
//                                 sellingPrice: selectedProduct!.sellingPrice,
//                                 purchasePrice: selectedProduct!.purchasePrice,
//                               );

//                           ref.invalidate(productListProvider);
//                           ref.invalidate(dashboardProvider);

//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text("Sale Successful 🎉")),
//                           );

//                           setState(() => selectedProduct = null);
//                         },
//                 child: const Text(
//                   "CONFIRM SALE",
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
