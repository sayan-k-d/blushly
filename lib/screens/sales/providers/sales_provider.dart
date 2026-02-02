import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/sales_repository.dart';

final salesRepositoryProvider = Provider<SalesRepository>(
  (ref) => SalesRepository(),
);
