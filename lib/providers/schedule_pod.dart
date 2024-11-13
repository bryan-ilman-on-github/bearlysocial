import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _ScheduleNotifier extends StateNotifier<SplayTreeMap> {
  _ScheduleNotifier() : super(SplayTreeMap());

  final fullDateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');

  void setState(SplayTreeMap timeSlots) {
    state = SplayTreeMap.from(timeSlots);
  }

  bool _hasOverlap({
    required DateTime toStart,
    required DateTime toEnd,
    String? rangeToSkip,
  }) {
    for (String key in state.keys) {
      if (key == rangeToSkip) continue;

      final dates = key.split('#');
      final existingStart = fullDateTimeFormat.parse(dates[0]);
      final existingEnd = fullDateTimeFormat.parse(dates[1]);

      if ((toStart.isAfter(existingStart) && toStart.isBefore(existingEnd)) ||
          (toEnd.isAfter(existingStart) && toEnd.isBefore(existingEnd)) ||
          (toStart.isBefore(existingStart) && toEnd.isAfter(existingEnd))) {
        return true;
      }
    }

    return false;
  }

  bool _hasConflictWithMeetups({
    required String dateTimeRange,
    required SplayTreeMap meetups,
  }) {
    List<String> dates = dateTimeRange.split('#');
    DateTime start = DateTime.parse(dates[0]);
    DateTime end = DateTime.parse(dates[1]);

    bool hasConflictWithMeetups = false;
    DateFormat shortDateTimeFormat = DateFormat('MMM dd, HH:mm');

    for (var key in meetups.keys) {
      DateTime meetupDateTime = shortDateTimeFormat.parse(key);
      if ((meetupDateTime.isBefore(start) && meetupDateTime.isBefore(end)) ||
          (meetupDateTime.isBefore(start) && meetupDateTime.isAfter(end)) ||
          (meetupDateTime.isAfter(start) && meetupDateTime.isAfter(end))) {
        hasConflictWithMeetups = true;
        continue;
      }
    }

    return hasConflictWithMeetups;
  }

  void addTimeSlotCollection(List<DateTime>? dateTimeRange) {
    if (dateTimeRange == null) return;

    if (!_hasOverlap(
      toStart: dateTimeRange[0],
      toEnd: dateTimeRange[1],
    )) {
      state['${fullDateTimeFormat.format(dateTimeRange[0])}#${fullDateTimeFormat.format(dateTimeRange[1])}'] =
          SplayTreeMap();
      state = SplayTreeMap.from(state);
    } else {
      // TODO
    }
  }

  void updateTimeSlotCollection({
    required List<DateTime>? currDateTimeRange,
    required String prevDateTimeRange,
    required SplayTreeMap meetups,
  }) {
    if (currDateTimeRange == null) return;

    String _currDateTimeRange =
        '${fullDateTimeFormat.format(currDateTimeRange[0])}#${fullDateTimeFormat.format(currDateTimeRange[1])}';

    if (!_hasOverlap(
          toStart: currDateTimeRange[0],
          toEnd: currDateTimeRange[1],
          rangeToSkip: prevDateTimeRange,
        ) &&
        !_hasConflictWithMeetups(
          dateTimeRange: _currDateTimeRange,
          meetups: meetups,
        )) {
      state.remove(prevDateTimeRange);
      state[_currDateTimeRange] = meetups;

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

final _scheduleNotifierProvider =
    StateNotifierProvider<_ScheduleNotifier, SplayTreeMap>(
  (ref) => _ScheduleNotifier(),
);

final schedule = Provider((ref) {
  return ref.watch(_scheduleNotifierProvider);
});

final setSchedule = Provider((ref) {
  return ref.read(_scheduleNotifierProvider.notifier).setState;
});

final addTimeSlots = Provider((ref) {
  return ref.read(_scheduleNotifierProvider.notifier).addTimeSlotCollection;
});

final updateTimeSlotColl = Provider((ref) {
  return ref.read(_scheduleNotifierProvider.notifier).updateTimeSlotCollection;
});

final deleteTimeSlotCollection = Provider((ref) {
  return ref.read(_scheduleNotifierProvider.notifier).deleteTimeSlotCollection;
});
