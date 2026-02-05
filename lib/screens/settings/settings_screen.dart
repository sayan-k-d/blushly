import 'dart:io';

import 'package:blushly/data/services/drive_backup_service.dart';
import 'package:blushly/screens/settings/providers/backup_provider.dart';
import 'package:blushly/screens/settings/widgets/restore_backup_bottom_sheet.dart';
import 'package:blushly/screens/settings/widgets/section_header.dart';
import 'package:blushly/screens/settings/widgets/settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  Future<void> showRestoreConfirm(
    BuildContext context,
    VoidCallback onConfirm,
  ) async {
    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Restore Backup"),
            content: const Text(
              "Restoring will replace all current data.\n\n"
              "The app must be restarted after restore.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onConfirm();
                },
                child: const Text("Restore"),
              ),
            ],
          ),
    );
  }

  Future<File?> pickBackupFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['db'],
    );

    if (result == null || result.files.single.path == null) {
      return null;
    }

    return File(result.files.single.path!);
  }

  Future<void> showRestartRequiredDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // ⛔ cannot dismiss
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            icon: Icon(Icons.check_circle, size: 48, color: Colors.green),
            title: const Text("Restart Required"),
            content: const Text(
              "Your data has been restored successfully.\n\n"
              "The app needs to restart to apply changes.",
            ),
            actions: [
              ElevatedButton.icon(
                icon: const Icon(Icons.restart_alt),
                label: const Text("Restart App"),
                onPressed: () {
                  SystemNavigator.pop(); // ✅ closes app safely
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings"), centerTitle: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionHeader("Backup & Data"),

          SettingsTile(
            icon: Icons.backup,
            title: "Backup data",
            subtitle: "Create a local backup of all data",
            onTap: () async {
              final file =
                  await ref.read(backupRepositoryProvider).createBackup();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Backup saved:\n${file.path}")),
              );
            },
          ),
          SizedBox(height: 12),

          SettingsTile(
            icon: Icons.restore,
            title: "Restore backup",
            subtitle: "Restore data from a backup file",
            isDestructive: true,
            onTap: () async {
              final file = await pickBackupFile();

              if (file == null) return;

              if (!file.path.endsWith('.db')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Invalid backup file")),
                );
                return;
              }

              await showRestoreConfirm(context, () async {
                await ref.read(backupRepositoryProvider).restoreBackup(file);

                await showRestartRequiredDialog(context);
              });
            },
          ),

          // SettingsTile(
          //   icon: Icons.restore,
          //   title: "Restore backup",
          //   subtitle: "Restore data from a backup file",
          //   isDestructive: true,
          //   onTap: () async {
          //     // Pick file here (file_picker)
          //     // For now assume `backupFile`
          //     final backupFile = File('path_to_backup.db');

          //     await showRestoreConfirm(context, () async {
          //       await ref
          //           .read(backupRepositoryProvider)
          //           .restoreBackup(backupFile);

          //       ScaffoldMessenger.of(context).showSnackBar(
          //         const SnackBar(
          //           content: Text(
          //             "Restore completed.\nPlease restart the app.",
          //           ),
          //         ),
          //       );
          //     });
          //   },
          // ),
          const SizedBox(height: 24),
          SectionHeader("Restore Data From Drive"),
          SettingsTile(
            icon: Icons.autorenew,
            title: "Restore Data",
            subtitle: "Restore Data from Drive",
            isDestructive: true,
            onTap: () async {
              // Show bottom sheet / dialog
              // User selects one → get driveFileId
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder:
                    (_) => RestoreBackupSheet(
                      showRestartDialog: showRestartRequiredDialog,
                    ),
              );

              // Restart Dialog
              // await showRestartRequiredDialog(context);
            },
          ),

          // const SizedBox(height: 24),

          // SectionHeader("Inventory"),

          // SettingsTile(
          //   icon: Icons.warning,
          //   title: "Low stock threshold",
          //   subtitle: "Default stock alert quantity",
          //   onTap: () {
          //     // open threshold dialog
          //   },
          // ),
          const SizedBox(height: 24),

          SectionHeader("About"),

          SettingsTile(
            icon: Icons.info_outline,
            title: "App version",
            subtitle: "Blushly POS v1.0.0",
            showArrow: false,
          ),
        ],
      ),
    );
  }
}
