import 'package:blushly/data/repositories/backup_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final backupRepositoryProvider = Provider((ref) => BackupRepository());
