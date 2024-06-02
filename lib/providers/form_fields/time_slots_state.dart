import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimeSlotsStateNotifier extends StateNotifier<SplayTreeMap> {
  TimeSlotsStateNotifier() : super(SplayTreeMap());

  final format = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');

  void setTimeSlots({required SplayTreeMap slots}) {
    state = slots;
  }

  bool _hasOverlap({
    required DateTime start,
    required DateTime end,
  }) {
    for (String key in state.keys) {
      final dates = key.split('#');
      final existingStart = format.parse(dates[0]);
      final existingEnd = format.parse(dates[1]);

      if ((start.isAfter(existingStart) && start.isBefore(existingEnd)) ||
          (end.isAfter(existingStart) && end.isBefore(existingEnd)) ||
          (start.isBefore(existingStart) && end.isAfter(existingEnd))) {
        return true;
      }
    }

    return false;
  }

  void addTimeSlot({
    required List<DateTime>? slot,
  }) {
    if (slot != null && !_hasOverlap(start: slot[0], end: slot[1])) {
      state['${format.format(slot[0])}#${format.format(slot[1])}'] =
          SplayTreeMap();
    } else {
      // TODO
    }
  }
}

final timeSlotsStateNotifierProvider =
    StateNotifierProvider<TimeSlotsStateNotifier, SplayTreeMap>(
  (ref) => TimeSlotsStateNotifier(),
);

final timeSlots = Provider((ref) {
  return ref.watch(timeSlotsStateNotifierProvider);
});

final setTimeSlots = Provider((ref) {
  return ref.read(timeSlotsStateNotifierProvider.notifier).setTimeSlots;
});

final addTimeSlot = Provider((ref) {
  return ref.read(timeSlotsStateNotifierProvider.notifier).addTimeSlot;
});
