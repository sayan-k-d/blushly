import 'package:blushly/core/providers/auto_backup_provider.dart';
import 'package:blushly/core/providers/theme_provider.dart';
import 'package:blushly/core/widgets/entry_animate.dart';
import 'package:blushly/screens/dashboard/providers/date_filter_provider.dart';
import 'package:blushly/screens/dashboard/providers/recent_activity_provider.dart';
import 'package:blushly/screens/dashboard/widgets/low_stock_preview.dart';
import 'package:blushly/screens/dashboard/widgets/quick_actions.dart';
import 'package:blushly/screens/dashboard/widgets/recent_activity.dart';
import 'package:blushly/screens/products/providers/product_provider.dart';
import 'package:blushly/screens/restock/providers/restock_history_provider.dart';
import 'package:blushly/screens/sales/providers/sell_history_provider.dart';
import 'package:blushly/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/dashboard_provider.dart';
import 'widgets/kpi_section.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  Future<void> _refreshDashboard(WidgetRef ref) async {
    ref.invalidate(dashboardProvider);
    ref.invalidate(productListProvider);
    ref.invalidate(sellHistoryProvider);
    ref.invalidate(restockHistoryProvider);
    ref.invalidate(recentActivityProvider);

    // Optional small delay for UX smoothness
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final productsAsync = ref.watch(productListProvider).value ?? [];
    final activitiesAsync = ref.watch(recentActivityProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // ref.listen(dashboardProvider, (_, __) {
    //   AutoBackupManager().runIfNeeded();
    // });

    // productsAsync.forEach(
    //   (products) {
    //     return LowStockPreview(
    //       products: products.where((p) => p.isLowStock).map((p) => p).toList(),
    //     );
    //   },
    // );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello"),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: "Toggle theme",
            icon: Icon(
              ref.watch(themeModeProvider) == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              final notifier = ref.read(themeModeProvider.notifier);
              notifier.state =
                  notifier.state == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => SettingsScreen()));
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: dashboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data:
            (data) => RefreshIndicator(
              onRefresh: () => _refreshDashboard(ref),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    EntryAnimate(
                      delay: const Duration(milliseconds: 0),
                      child: KpiSection(data: data),
                    ),
                    const SizedBox(height: 20),

                    // 🔹 Recent Activity Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Recent Activities",
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Consumer(
                                builder: (_, ref, __) {
                                  final filter = ref.watch(dateFilterProvider);
                                  return DropdownButton<DateFilter>(
                                    value: filter,
                                    underline: const SizedBox(),
                                    items: const [
                                      DropdownMenuItem(
                                        value: DateFilter.today,
                                        child: Text("Today"),
                                      ),
                                      DropdownMenuItem(
                                        value: DateFilter.month,
                                        child: Text("This Month"),
                                      ),
                                    ],
                                    onChanged: (val) {
                                      ref
                                          .read(dateFilterProvider.notifier)
                                          .state = val!;
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          EntryAnimate(
                            delay: const Duration(milliseconds: 100),
                            child: activitiesAsync.when(
                              loading:
                                  () => const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: CircularProgressIndicator(),
                                  ),
                              error:
                                  (e, _) => Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text("Error: $e"),
                                  ),
                              data:
                                  (activities) => RecentActivitySection(
                                    activities: activities,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 🔹 Quick Actions (FIXED HEIGHT)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Quick Actions",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(height: 12),

                          EntryAnimate(
                            delay: const Duration(milliseconds: 200),
                            child: QuickActions(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 🔹 Low Stock Preview
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: EntryAnimate(
                        delay: const Duration(milliseconds: 300),
                        child: LowStockPreview(products: productsAsync),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
