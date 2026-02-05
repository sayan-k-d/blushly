import 'package:blushly/core/providers/auto_backup_provider.dart';
import 'package:blushly/core/providers/theme_provider.dart';
import 'package:blushly/core/theme/app_theme.dart';
import 'package:blushly/data/db/app_database.dart';
import 'package:blushly/screens/splash/birthday_splash.dart';
import 'package:blushly/screens/splash/splash_logic.dart';
import 'package:blushly/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await AppDatabase.instance.resetDatabase();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      AutoBackupManager().runIfNeeded();
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final isBirthday = SplashLogic.isBirthday(today);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ref.watch(themeModeProvider),

      // ✅ CONDITIONAL RENDERING
      home: isBirthday ? const BirthdaySplash() : const SplashScreen(),
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final today = DateTime.now();
//     final isBirthday = SplashLogic.isBirthday(today);

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.lightTheme,

//       // ✅ CONDITIONAL RENDERING
//       home: isBirthday ? const BirthdaySplash() : const SplashScreen(),
//     );
//   }
// }
