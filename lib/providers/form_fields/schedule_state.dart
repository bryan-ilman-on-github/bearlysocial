import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleStateNotifier extends StateNotifier<SplayTreeMap> {
  ScheduleStateNotifier() : super(SplayTreeMap());

  final format = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');

  void updateSchedule({required SplayTreeMap timeSlots}) {
    state = SplayTreeMap.from(timeSlots);
  }

  bool _hasOverlap({
    required DateTime toStart,
    required DateTime toEnd,
  }) {
    for (String key in state.keys) {
      final dates = key.split('#');
      final existingStart = format.parse(dates[0]);
      final existingEnd = format.parse(dates[1]);

      if ((toStart.isAfter(existingStart) && toStart.isBefore(existingEnd)) ||
          (toEnd.isAfter(existingStart) && toEnd.isBefore(existingEnd)) ||
          (toStart.isBefore(existingStart) && toEnd.isAfter(existingEnd))) {
        return true;
      }
    }

    return false;
  }

  void addTimeSlotCollection({
    required List<DateTime>? collection,
  }) {
    if (collection != null &&
        !_hasOverlap(
          toStart: collection[0],
          toEnd: collection[1],
        )) {
      state['${format.format(collection[0])}#${format.format(collection[1])}'] =
          SplayTreeMap();
      state = SplayTreeMap.from(state);
    } else {
      // TODO
    }
  }

  void deleteTimeSlotCollection({
    required String dateTimeRange,
  }) {
    state.remove(dateTimeRange);
    state = SplayTreeMap.from(state);
  }
}

final scheduleStateNotifierProvider =
    StateNotifierProvider<ScheduleStateNotifier, SplayTreeMap>(
  (ref) => ScheduleStateNotifier(),
);

final schedule = Provider((ref) {
  return ref.watch(scheduleStateNotifierProvider);
});

final updateSchedule = Provider((ref) {
  return ref.read(scheduleStateNotifierProvider.notifier).updateSchedule;
});

final addTimeSlotCollection = Provider((ref) {
  return ref.read(scheduleStateNotifierProvider.notifier).addTimeSlotCollection;
});

final deleteTimeSlotCollection = Provider((ref) {
  return ref
      .read(scheduleStateNotifierProvider.notifier)
      .deleteTimeSlotCollection;
});
