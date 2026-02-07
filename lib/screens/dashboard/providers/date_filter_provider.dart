import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

enum DateFilter { today, month }

final dateFilterProvider = StateProvider<DateFilter>((ref) => DateFilter.today);
