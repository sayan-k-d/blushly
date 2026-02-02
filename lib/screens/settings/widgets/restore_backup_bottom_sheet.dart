import 'package:blushly/data/services/drive_backup_service.dart';
import 'package:blushly/screens/settings/providers/drive_backup_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class RestoreBackupSheet extends ConsumerWidget {
  final Future<void> Function(BuildContext) showRestartDialog;
  const RestoreBackupSheet({super.key, required this.showRestartDialog});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBackups = ref.watch(driveBackupsProvider);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Handle ───────────────────────────────
              Center(
                child: Container(
                  height: 5,
                  width: 40,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // ─── Header ───────────────────────────────
              const Text(
                'Restore Backup',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                'Select a backup to restore',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),

              const SizedBox(height: 16),

              // ─── Async Content ─────────────────────────
              Expanded(
                child: asyncBackups.when(
                  loading:
                      () => const Center(child: CircularProgressIndicator()),

                  error:
                      (e, _) => Center(
                        child: Text(
                          'Error loading backups\n$e',
                          textAlign: TextAlign.center,
                        ),
                      ),

                  data: (files) {
                    if (files.isEmpty) {
                      return const Center(child: Text('No backups found'));
                    }

                    return ListView.separated(
                      controller: controller,
                      itemCount: files.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final drive.File f = files[i];
                        final sizeKb = ((int.tryParse(f.size ?? '0') ?? 0) /
                                1024)
                            .toStringAsFixed(1);

                        return _BackupTile(
                          file: f,
                          sizeKb: sizeKb,
                          onRestore: () async {
                            final confirm = await _confirmRestore(context);
                            if (!confirm) return;

                            // Navigator.pop(context); // close sheet

                            await DriveBackupService().restoreBackup(f.id!);
                            await showRestartDialog(context);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BackupTile extends StatelessWidget {
  final drive.File file;
  final String sizeKb;
  final VoidCallback onRestore;

  const _BackupTile({
    required this.file,
    required this.sizeKb,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onRestore,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[50],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.cloud_done, color: Colors.green),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.name ?? 'Backup',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${file.createdTime?.toLocal().toString().split(".").first} • $sizeKb KB',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            const Icon(Icons.restore, size: 20),
          ],
        ),
      ),
    );
  }
}

Future<bool> _confirmRestore(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Restore Backup'),
              content: const Text(
                'This will overwrite your current data. Continue?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Restore'),
                ),
              ],
            ),
      ) ??
      false;
}
