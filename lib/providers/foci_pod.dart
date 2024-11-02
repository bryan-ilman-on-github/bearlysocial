import 'package:flutter_riverpod/flutter_riverpod.dart';

class _FocusNotifier extends StateNotifier<bool> {
  _FocusNotifier() : super(false);

  void toggleState() => state = !state;
}

final _firstNameFocusPod =
    StateNotifierProvider<_FocusNotifier, bool>((ref) => _FocusNotifier());
final _lastNameFocusPod =
    StateNotifierProvider<_FocusNotifier, bool>((ref) => _FocusNotifier());

final firstNameFocus = Provider((ref) => ref.watch(_firstNameFocusPod));
final lastNameFocus = Provider((ref) => ref.watch(_lastNameFocusPod));

final toggleFirstNameFocus =
    Provider((ref) => ref.read(_firstNameFocusPod.notifier).toggleState);
final toggleLastNameFocus =
    Provider((ref) => ref.read(_lastNameFocusPod.notifier).toggleState);
