import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/restock_repository.dart';

final restockRepositoryProvider = Provider<RestockRepository>(
  (ref) => RestockRepository(),
);
