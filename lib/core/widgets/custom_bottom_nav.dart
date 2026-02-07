import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/bottom_nav_provider.dart';

class CustomBottomNav extends ConsumerWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return FlashyTabBar(
      animationDuration: Duration(milliseconds: 400),
      selectedIndex: currentIndex,
      showElevation: true,
      onItemSelected: (index) {
        ref.read(bottomNavIndexProvider.notifier).state = index;
      },
      animationCurve: Curves.easeInOut,
      backgroundColor: isDark ? const Color(0xFF470A1F) : Colors.white,
      iconSize: 25,
      items: [
        FlashyTabBarItem(
          icon: Icon(Icons.dashboard),
          title: Text('Dashboard'),
          activeColor:
              isDark ? Theme.of(context).colorScheme.secondary : Colors.pink,
        ),
        FlashyTabBarItem(
          icon: Icon(Icons.inventory),
          title: Text('Products'),
          activeColor:
              isDark ? Theme.of(context).colorScheme.secondary : Colors.pink,
        ),
        FlashyTabBarItem(
          icon: Icon(Icons.category),
          title: Text('Categories'),
          activeColor:
              isDark ? Theme.of(context).colorScheme.secondary : Colors.pink,
        ),
        FlashyTabBarItem(
          icon: Icon(Icons.point_of_sale),
          title: Text('Quick Sell'),
          activeColor:
              isDark ? Theme.of(context).colorScheme.secondary : Colors.pink,
        ),
      ],
    );

    // return Container(
    //   height: 70,
    //   margin: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
    //   decoration: BoxDecoration(
    //     color: isDark ? Colors.pink.withOpacity(0.12) : Colors.white,
    //     borderRadius: const BorderRadius.vertical(
    //       top: Radius.circular(16),
    //       bottom: Radius.circular(16),
    //     ),
    //     boxShadow: [
    //       BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12),
    //     ],
    //   ),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //     children: [
    //       _NavItem(
    //         index: 0,
    //         icon: Icons.dashboard,
    //         label: "Dashboard",
    //         isActive: currentIndex == 0,
    //         onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 0,
    //       ),
    //       _NavItem(
    //         index: 1,
    //         icon: Icons.inventory,
    //         label: "Products",
    //         isActive: currentIndex == 1,
    //         onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 1,
    //       ),
    //       _NavItem(
    //         index: 2,
    //         icon: Icons.category,
    //         label: "Categories",
    //         isActive: currentIndex == 2,
    //         onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 2,
    //       ),
    //       _NavItem(
    //         index: 3,
    //         icon: Icons.point_of_sale,
    //         label: "Sales",
    //         isActive: currentIndex == 3,
    //         onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 3,
    //       ),
    //     ],
    //   ),
    // );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color =
        isActive
            ? isDark
                ? Theme.of(context).colorScheme.onPrimary
                : Colors.pink
            : isDark
            ? Colors.grey[500]
            : Colors.grey;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              isActive
                  ? isDark
                      ? Theme.of(context).colorScheme.secondary.withOpacity(0.6)
                      : Colors.pink.withOpacity(0.15)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isActive ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 4),
            AnimatedOpacity(
              opacity: isActive ? 1 : 0.7,
              duration: const Duration(milliseconds: 200),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
