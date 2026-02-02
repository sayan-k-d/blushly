import 'package:blushly/screens/categories/category_list_screen.dart';
import 'package:blushly/screens/dashboard/dashboard_screen.dart';
import 'package:blushly/screens/products/product_list_screen.dart';
import 'package:blushly/screens/sales/sales_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/bottom_nav_provider.dart';
import 'custom_bottom_nav.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomNavIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: const [
          DashboardScreen(),
          ProductListScreen(),
          CategoryListScreen(),
          SalesScreen(), // placeholder for now
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}
