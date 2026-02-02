import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DateFilter { today, month }

final dateFilterProvider = StateProvider<DateFilter>((ref) => DateFilter.today);
