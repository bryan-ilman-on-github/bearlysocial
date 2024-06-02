import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimeSlotsStateNotifier extends StateNotifier<SplayTreeMap> {
  TimeSlotsStateNotifier() : super(SplayTreeMap());

  void setState({required SplayTreeMap slots}) {
    state = slots;
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
  return ref.read(timeSlotsStateNotifierProvider.notifier).setState;
});
