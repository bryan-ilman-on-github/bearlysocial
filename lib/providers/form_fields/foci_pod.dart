import 'package:flutter_riverpod/flutter_riverpod.dart';

class _FocusNotifier extends StateNotifier<bool> {
  _FocusNotifier() : super(false);

  void toggleState() => state = !state;
}

final _firstNameFocusProd =
    StateNotifierProvider<_FocusNotifier, bool>((ref) => _FocusNotifier());
final _lastNameFocusProd =
    StateNotifierProvider<_FocusNotifier, bool>((ref) => _FocusNotifier());

final firstNameFocus = Provider((ref) => ref.watch(_firstNameFocusProd));
final lastNameFocus = Provider((ref) => ref.watch(_lastNameFocusProd));

final toggleFirstNameFocus =
    Provider((ref) => ref.read(_firstNameFocusProd.notifier).toggleState);
final toggleLastNameFocus =
    Provider((ref) => ref.read(_lastNameFocusProd.notifier).toggleState);
