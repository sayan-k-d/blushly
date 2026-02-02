import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import '../db/app_database.dart';

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}

class DriveBackupService {
  Future<String> getOrCreateBackupFolder(drive.DriveApi driveApi) async {
    // 1️⃣ Check if folder exists
    final result = await driveApi.files.list(
      q:
          "mimeType='application/vnd.google-apps.folder' "
          "and name='BlushlyBackup' and trashed=false",
      spaces: 'drive',
      $fields: 'files(id, name)',
    );

    if (result.files != null && result.files!.isNotEmpty) {
      return result.files!.first.id!;
    }

    // 2️⃣ Create folder if not found
    final folder =
        drive.File()
          ..name = 'BlushlyBackup'
          ..mimeType = 'application/vnd.google-apps.folder';

    final createdFolder = await driveApi.files.create(folder);
    return createdFolder.id!;
  }
  // 'https://www.googleapis.com/auth/drive.appdata',
  // 'https://www.googleapis.com/auth/drive.file',
  // 'https://www.googleapis.com/auth/userinfo.profile',

  Future<drive.DriveApi> _getDriveApi() async {
    final googleSignIn = GoogleSignIn(
      scopes: [
        'https://www.googleapis.com/auth/drive.file',
        'https://www.googleapis.com/auth/userinfo.profile',
      ],
    );

    // await googleSignIn.signOut(); // for 1 time only
    final account = await googleSignIn.signIn();
    if (account == null) {
      throw Exception('Google sign-in cancelled');
    }

    final authHeaders = await account.authHeaders;
    final client = GoogleAuthClient(authHeaders);

    return drive.DriveApi(client);
  }

  // Upload to BlushlyBackup Visible folder
  Future<String> uploadBackupToDrive(File dbFile) async {
    final driveApi = await _getDriveApi();

    final folderId = await getOrCreateBackupFolder(driveApi);

    final media = drive.Media(dbFile.openRead(), dbFile.lengthSync());

    final file =
        drive.File()
          ..name = 'blushly_backup_${DateTime.now().millisecondsSinceEpoch}.db'
          ..parents = [folderId];

    final result = await driveApi.files.create(file, uploadMedia: media);

    return result.id!;
  }

  Future<List<drive.File>> listBackups() async {
    final api = await _getDriveApi();

    final folderId = await getOrCreateBackupFolder(api);

    final result = await api.files.list(
      q: "'$folderId' in parents and trashed=false",
      orderBy: 'createdTime desc',
      $fields: 'files(id, name, createdTime, size)',
    );

    return result.files ?? [];
  }

  Future<void> restoreBackup(String driveFileId) async {
    final api = await _getDriveApi();

    // 1️⃣ Close database
    await AppDatabase.instance.close();

    // 2️⃣ Prepare local DB path
    final dbPath = await getDatabasesPath();
    final localFile = File('$dbPath/cosmetics_shop.db');

    // 3️⃣ Download from Drive
    final media =
        await api.files.get(
              driveFileId,
              downloadOptions: drive.DownloadOptions.fullMedia,
            )
            as drive.Media;

    final sink = localFile.openWrite();
    await media.stream.pipe(sink);
    await sink.flush();
    await sink.close();

    // 4️⃣ Reopen DB
    await AppDatabase.instance.database;
  }

  Future<void> deleteBackup(String fileId) async {
    final api = await _getDriveApi();
    await api.files.delete(fileId);
  }

  // Upload to AppData hidden folder
  // Future<String> uploadBackup(File dbFile) async {
  //   final api = await _getDriveApi();

  //   final media = drive.Media(dbFile.openRead(), dbFile.lengthSync());

  //   final file =
  //       drive.File()
  //         ..name = 'blushly_backup_${DateTime.now().millisecondsSinceEpoch}.db'
  //         ..parents = ['appDataFolder'];

  //   final result = await api.files.create(file, uploadMedia: media);

  //   return result.id!;
  // }
}
