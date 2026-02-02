import 'dart:io';
import 'package:blushly/data/db/app_database.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class BackupRepository {
  Future<File> createBackup() async {
    final dbPath = await getDatabasesPath();
    final source = File(join(dbPath, 'cosmetics_shop.db'));

    if (!await source.exists()) {
      throw Exception('Database not found');
    }

    // final dir = await getApplicationDocumentsDirectory();
    // final backupDir = Directory(join(dir.path, 'backups'));
    Directory? downloadsDir;
    if (Platform.isAndroid) {
      downloadsDir = Directory('/storage/emulated/0/Download');
    } else {
      // fallback for iOS / others
      downloadsDir = await getApplicationDocumentsDirectory();
    }
    final backupDir = Directory(join(downloadsDir.path, 'BlushlyBackups'));

    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    final backupFile = File(
      join(
        backupDir.path,
        'cosmetics_backup_${DateTime.now().millisecondsSinceEpoch}.db',
      ),
    );

    return source.copy(backupFile.path);
  }

  Future<void> restoreBackup(File backup) async {
    final dbPath = await getDatabasesPath();
    final target = File(join(dbPath, 'cosmetics_shop.db'));

    await AppDatabase.instance.close();
    await backup.copy(target.path);
  }
}
