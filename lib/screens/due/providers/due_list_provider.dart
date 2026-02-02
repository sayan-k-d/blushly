import 'package:blushly/data/db/app_database.dart';
import 'package:blushly/screens/due/providers/due_search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dueListProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final db = await AppDatabase.instance.database;
  final search = ref.watch(dueSearchProvider);

  final conditions = <String>['s.is_due = 1'];
  final args = <dynamic>[];

  if (search.isNotEmpty) {
    conditions.add('(s.customer_name LIKE ? OR s.customer_phone LIKE ?)');
    args.add('%$search%');
    args.add('%$search%');
  }

  final whereClause = 'WHERE ${conditions.join(' AND ')}';

  return await db.rawQuery('''
    SELECT
      s.id,
      s.customer_name,
      s.customer_phone,
      p.name AS product_name,
      SUM(s.due_amount) AS total_due,
      COUNT(*) AS due_count,
      MAX(s.created_at) AS last_due_at
    FROM sales s
    JOIN products p ON p.id = s.product_id
    $whereClause
    GROUP BY s.customer_name, s.customer_phone, p.name
    ORDER BY last_due_at DESC
  ''', args);
});
