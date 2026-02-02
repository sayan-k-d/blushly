import 'package:blushly/data/services/drive_backup_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final driveBackupsProvider = FutureProvider((ref) async {
  return DriveBackupService().listBackups();
});
