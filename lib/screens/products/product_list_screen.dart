import 'package:blushly/screens/products/widgets/product_list_tab.dart';
import 'package:blushly/screens/restock/restock_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: "Products"), Tab(text: "Restock History")],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [ProductListTab(), RestockHistoryTab()],
      ),
    );
  }
}
