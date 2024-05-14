import 'package:flutter_riverpod/flutter_riverpod.dart';

class LastNameFocusStateNotifier extends StateNotifier<bool> {
  LastNameFocusStateNotifier() : super(false);

  void toggleFocus() {
    state = !state;
  }
}

final lastNameFocusStateNotifierProvider =
    StateNotifierProvider<LastNameFocusStateNotifier, bool>(
  (ref) => LastNameFocusStateNotifier(),
);

final lastNameFocusState = Provider((ref) {
  return ref.watch(lastNameFocusStateNotifierProvider);
});

final toggleLastNameFocusState = Provider((ref) {
  return ref.read(lastNameFocusStateNotifierProvider.notifier).toggleFocus;
});
