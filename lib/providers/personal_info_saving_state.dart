import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalInfoEditingStateNotifier extends StateNotifier<bool> {
  PersonalInfoEditingStateNotifier() : super(false);

  void setPersonalInfoEditingState({required bool value}) {
    state = value;
  }
}

final personalInfoEditingStateNotifierProvider =
    StateNotifierProvider<PersonalInfoEditingStateNotifier, bool>(
  (ref) => PersonalInfoEditingStateNotifier(),
);

final isPersonalInfoEdited = Provider((ref) {
  return ref.watch(personalInfoEditingStateNotifierProvider);
});

final setPersonalInfoEditingState = Provider((ref) {
  return ref
      .read(personalInfoEditingStateNotifierProvider.notifier)
      .setPersonalInfoEditingState;
});
