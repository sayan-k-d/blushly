import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../data/models/category_model.dart';
import '../../../data/repositories/category_repository.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => CategoryRepository(),
);

final categoryListProvider = FutureProvider<List<Category>>((ref) async {
  final repo = ref.read(categoryRepositoryProvider);
  return repo.getCategories();
});

final categorySearchProvider = StateProvider<String>((ref) => '');
