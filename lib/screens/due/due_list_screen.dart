import 'dart:async';

import 'package:blushly/screens/due/providers/due_history_provider.dart';
import 'package:blushly/screens/due/providers/due_list_provider.dart';
import 'package:blushly/screens/due/providers/due_search_provider.dart';
import 'package:blushly/screens/due/widgets/due_customer_card.dart';
import 'package:blushly/screens/due/widgets/due_empty_state.dart';
import 'package:blushly/screens/due/widgets/no_search_result_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DueListScreen extends ConsumerStatefulWidget {
  const DueListScreen({super.key});

  @override
  ConsumerState<DueListScreen> createState() => _DueListScreenState();
}

class _DueListScreenState extends ConsumerState<DueListScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    // 🔄 force refresh when screen opens
    Future.microtask(() {
      ref.invalidate(dueListProvider);
      ref.invalidate(dueHistoryProvider);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    // Re-fetch latest dues
    _searchController.clear();
    ref.read(dueSearchProvider.notifier).state = '';
    ref.invalidate(dueListProvider);

    // Small delay so refresh animation feels natural
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    final dueAsync = ref.watch(dueListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Due Payments"), centerTitle: false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search by name or mobile",
              ),
              onChanged:
                  (val) => ref.read(dueSearchProvider.notifier).state = val,
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                child: dueAsync.when(
                  data: (list) {
                    final search = ref.watch(dueSearchProvider);
                    setState(() {
                      _searchController.text = search;
                    });
                    final filtered =
                        search.isEmpty
                            ? list
                            : list.where((d) {
                              final name =
                                  (d['customer_name'] as String?)
                                      ?.toLowerCase() ??
                                  '';
                              final phone =
                                  (d['customer_phone'] as String?)
                                      ?.toLowerCase() ??
                                  '';

                              return name.contains(search.toLowerCase()) ||
                                  phone.contains(search.toLowerCase());
                            }).toList();

                    if (filtered.isEmpty) {
                      if (search.isNotEmpty) {
                        return NoSearchResultsState();
                      }

                      // No dues at all
                      return const DueEmptyState();
                    }
                    return ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => DueCustomerCard(data: filtered[i]),
                    );
                  },
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text("Error: $e")),
                ),
              ),
            ),
          ),
        ],
      ),

      // dueAsync.when(
      //   loading: () => const Center(child: CircularProgressIndicator()),
      //   error: (e, _) => Center(child: Text("Error: $e")),
      //   data: (list) {
      //     final search = ref.watch(dueSearchProvider);
      //     setState(() {
      //       _searchController.text = search;
      //     });
      //     return Column(
      //       children: [
      //         // 🔍 SEARCH BAR — ALWAYS VISIBLE
      //         Padding(
      //           padding: const EdgeInsets.all(12),
      //           child: TextField(
      //             controller: _searchController,
      //             decoration: const InputDecoration(
      //               prefixIcon: Icon(Icons.search),
      //               hintText: "Search by name or mobile",
      //             ),
      //             onChanged: _onSearchChanged,
      //           ),
      //         ),

      //         // 📄 CONTENT AREA
      //         Expanded(
      //           child: RefreshIndicator(
      //             onRefresh: _onRefresh,
      //             child: Builder(
      //               builder: (_) {
      //                 if (list.isEmpty) {
      //                   // Search applied → no results
      //                   if (search.isNotEmpty) {
      //                     return const NoSearchResultsState();
      //                   }

      //                   // No dues at all
      //                   return const DueEmptyState();
      //                 }

      //                 return ListView.separated(
      //                   padding: const EdgeInsets.all(16),
      //                   itemCount: list.length,
      //                   separatorBuilder: (_, __) => const SizedBox(height: 12),
      //                   itemBuilder: (_, i) => DueCustomerCard(data: list[i]),
      //                 );
      //               },
      //             ),
      //           ),
      //         ),
      //       ],
      //     );
      //   },
      // ),
    );
  }
}
