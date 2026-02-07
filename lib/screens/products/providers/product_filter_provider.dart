import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final productSearchProvider = StateProvider<String>((ref) => '');

final productCategoryFilterProvider = StateProvider<int?>(
  (ref) => null,
); // null = all categories
