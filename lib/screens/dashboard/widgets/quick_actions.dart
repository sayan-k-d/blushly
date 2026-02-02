import 'package:blushly/screens/dashboard/widgets/quick_action_tile.dart';
import 'package:blushly/screens/due/due_list_screen.dart';
import 'package:blushly/screens/products/add_edit_product_screen.dart';
import 'package:blushly/screens/products/low_stock_products_screen.dart';
import 'package:blushly/screens/restock/restock_sheet.dart';
import 'package:blushly/screens/sales/quick_sell_tab.dart';
import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        QuickActionTile(
          icon: Icons.add,
          label: "Add Product",
          color: Colors.pink,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddEditProductScreen()),
            );
          },
        ),
        QuickActionTile(
          icon: Icons.flash_on,
          label: "Quick Sell",
          color: Colors.green,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const QuickSellTab(isTab: false),
              ),
            );
          },
        ),
        // QuickActionTile(
        //   icon: Icons.add_box,
        //   label: "Restock",
        //   color: Colors.blue,
        //   onTap: () {
        //     showModalBottomSheet(
        //       context: context,
        //       isScrollControlled: true,
        //       shape: const RoundedRectangleBorder(
        //         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        //       ),
        //       builder: (_) => RestockSheet(),
        //     );
        //   },
        // ),
        QuickActionTile(
          icon: Icons.schedule,
          label: "Due List",
          color: Colors.orange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DueListScreen()),
            );
          },
        ),
        QuickActionTile(
          icon: Icons.warning,
          label: "Low Stock",
          color: Colors.red,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LowStockProductsScreen()),
            );
          },
        ),
      ],
    );
  }
}
