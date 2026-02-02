import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import '../../../data/db/app_database.dart';

final dashboardProvider = FutureProvider<DashboardData>((ref) async {
  final db = await AppDatabase.instance.database;

  final today = DateTime.now().toIso8601String().substring(0, 10);
  double _sumDouble(List<Map<String, Object?>> result) {
    final value = result.first.values.first;
    if (value == null) return 0.0;
    return (value as num).toDouble();
  }

  final todayProfitResult = await db.rawQuery(
    "SELECT SUM(profit) FROM sales WHERE created_at LIKE '$today%'",
  );

  final monthlyProfitResult = await db.rawQuery("""
  SELECT SUM(profit) FROM sales
  WHERE strftime('%Y-%m', created_at) = strftime('%Y-%m', 'now')
  """);

  final todayProfit = _sumDouble(todayProfitResult);
  final monthlyProfit = _sumDouble(monthlyProfitResult);

  // final todayProfit =
  //     Sqflite.firstIntValue(
  //       await db.rawQuery('''
  //   SELECT SUM(profit) FROM sales
  //   WHERE created_at LIKE '$today%'
  //   '''),
  //     ) ??
  //     0;

  // final monthlyProfit =
  //     Sqflite.firstIntValue(
  //       await db.rawQuery('''
  //   SELECT SUM(profit) FROM sales
  //   WHERE strftime('%Y-%m', created_at) = strftime('%Y-%m', 'now')
  //   '''),
  //     ) ??
  //     0;

  final totalStock =
      Sqflite.firstIntValue(
        await db.rawQuery('SELECT SUM(quantity) FROM products'),
      ) ??
      0;

  final soldToday =
      Sqflite.firstIntValue(
        await db.rawQuery('''
    SELECT SUM(quantity) FROM sales
    WHERE created_at LIKE '$today%'
    '''),
      ) ??
      0;

  return DashboardData(
    todayProfit: todayProfit.toDouble(),
    monthlyProfit: monthlyProfit.toDouble(),
    totalStock: totalStock,
    soldToday: soldToday,
  );
});

class DashboardData {
  final double todayProfit;
  final double monthlyProfit;
  final int totalStock;
  final int soldToday;

  DashboardData({
    required this.todayProfit,
    required this.monthlyProfit,
    required this.totalStock,
    required this.soldToday,
  });
}
