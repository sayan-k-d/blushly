import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/category_model.dart';
import 'providers/category_provider.dart';

class AddEditCategoryScreen extends ConsumerStatefulWidget {
  final Category? category;

  const AddEditCategoryScreen({super.key, this.category});

  @override
  ConsumerState<AddEditCategoryScreen> createState() =>
      _AddEditCategoryScreenState();
}

class _AddEditCategoryScreenState extends ConsumerState<AddEditCategoryScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.category == null ? "Add Category" : "Edit Category"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Category Name"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDark
                        ? Theme.of(context).colorScheme.onTertiaryFixed
                        : null,
                foregroundColor:
                    isDark ? Theme.of(context).colorScheme.onSurface : null,
              ),
              onPressed: () async {
                final name = _nameController.text.trim();
                if (name.isEmpty) return;

                final repo = ref.read(categoryRepositoryProvider);

                if (widget.category == null) {
                  await repo.addCategory(
                    Category(
                      name: name,
                      createdAt: DateTime.now().toIso8601String(),
                    ),
                  );
                } else {
                  await repo.updateCategory(
                    widget.category!.copyWith(name: name),
                  );
                }

                ref.invalidate(categoryListProvider);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
