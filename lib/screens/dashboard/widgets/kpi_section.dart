import 'package:flutter/material.dart';
import '../providers/dashboard_provider.dart';
import 'kpi_card.dart';

class KpiSection extends StatelessWidget {
  final DashboardData data;

  const KpiSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
        children: [
          KpiCard(
            title: "Today Profit",
            value: "₹ ${data.todayProfit}",
            icon: Icons.today,
            color: Colors.green,
          ),
          KpiCard(
            title: "Monthly Profit",
            value: "₹ ${data.monthlyProfit}",
            icon: Icons.bar_chart,
            color: Colors.blue,
          ),
          KpiCard(
            title: "Total Stock",
            value: data.totalStock.toString(),
            icon: Icons.inventory,
            color: Colors.orange,
          ),
          KpiCard(
            title: "Sold Today",
            value: data.soldToday.toString(),
            icon: Icons.shopping_cart,
            color: Colors.pink,
          ),
        ],
      ),
    );
  }
}
