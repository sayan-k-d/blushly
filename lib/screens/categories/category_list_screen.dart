import 'package:blushly/screens/categories/add_edit_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/category_provider.dart';

class CategoryListScreen extends ConsumerWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsync = ref.watch(categoryListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Categories"), centerTitle: false),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_category_btn',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditCategoryScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search categories",
              ),
              onChanged:
                  (val) =>
                      ref.read(categorySearchProvider.notifier).state = val,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: categoryAsync.when(
                data: (categories) {
                  final search = ref.watch(categorySearchProvider);

                  final filtered =
                      categories
                          .where(
                            (c) => c.name.toLowerCase().contains(
                              search.toLowerCase(),
                            ),
                          )
                          .toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text("No categories found"));
                  }
                  return ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final category = filtered[i];
                      return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(24),
                        ),
                        tileColor:
                            isDark
                                ? Theme.of(context).colorScheme.onPrimary
                                : Colors.pink.withOpacity(0.12),
                        leading: const Icon(Icons.category),
                        title: Text(category.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => AddEditCategoryScreen(
                                          category: category,
                                        ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await ref
                                    .read(categoryRepositoryProvider)
                                    .deleteCategory(category.id!);
                                ref.invalidate(categoryListProvider);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("Error: $e")),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
