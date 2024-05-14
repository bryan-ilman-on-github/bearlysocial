import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirstNameFocusStateNotifier extends StateNotifier<bool> {
  FirstNameFocusStateNotifier() : super(false);

  void toggleFocus() {
    state = !state;
  }
}

final firstNameFocusStateNotifierProvider =
    StateNotifierProvider<FirstNameFocusStateNotifier, bool>(
  (ref) => FirstNameFocusStateNotifier(),
);

final firstNameFocusState = Provider((ref) {
  return ref.watch(firstNameFocusStateNotifierProvider);
});

final toggleFirstNameFocusState = Provider((ref) {
  return ref.read(firstNameFocusStateNotifierProvider.notifier).toggleFocus;
});
