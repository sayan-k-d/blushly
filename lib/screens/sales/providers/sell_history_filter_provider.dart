import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

enum SaleFilter { all, dueOnly }

final sellHistorySearchProvider = StateProvider<String>((ref) => '');

final sellHistoryCategoryProvider = StateProvider<int?>((ref) => null);

final sellHistoryDateRangeProvider = StateProvider<DateTimeRange?>(
  (ref) => null,
);

final saleFilterProvider = StateProvider<SaleFilter>((ref) => SaleFilter.all);
