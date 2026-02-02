import 'dart:io';

import 'package:blushly/data/db/app_database.dart';
import 'package:blushly/data/services/drive_backup_service.dart';
import 'package:sqflite/sqflite.dart';

class AutoBackupManager {
  static const int intervalDays = 15;
  static const int maxBackups = 2;

  static bool _hasRunThisSession = false;

  Future<void> runIfNeeded() async {
    if (_hasRunThisSession) return;
    _hasRunThisSession = true;

    final db = await AppDatabase.instance.database;

    final meta = await db.query(
      'app_meta',
      where: 'key = ?',
      whereArgs: ['last_backup_at'],
      limit: 1,
    );

    if (meta.isNotEmpty) {
      final last = DateTime.parse(meta.first['value'] as String);
      if (DateTime.now().difference(last).inDays < intervalDays) return;
    }

    final dbPath = await getDatabasesPath();
    final file = File('$dbPath/cosmetics_shop.db');

    final driveService = DriveBackupService();
    final driveFileId = await driveService.uploadBackupToDrive(file);

    await db.insert('cloud_backups', {
      'drive_file_id': driveFileId,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('app_meta', {
      'key': 'last_backup_at',
      'value': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    final backups = await db.query('cloud_backups', orderBy: 'created_at ASC');

    if (backups.length > maxBackups) {
      final oldest = backups.first;
      await driveService.deleteBackup(oldest['drive_file_id'] as String);
      await db.delete(
        'cloud_backups',
        where: 'id = ?',
        whereArgs: [oldest['id']],
      );
    }
  }
}
