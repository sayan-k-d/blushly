import 'package:blushly/data/repositories/due_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dueRepositoryProvider = Provider<DueRepository>((ref) {
  return DueRepository();
});
