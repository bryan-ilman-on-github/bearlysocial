import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormProfileSaveStateNotifier extends StateNotifier<bool> {
  FormProfileSaveStateNotifier() : super(true);

  void setState({
    required bool newBool,
  }) {
    state = newBool;
  }
}

final formProfileSaveStateNotifierProvider =
    StateNotifierProvider<FormProfileSaveStateNotifier, bool>(
  (ref) => FormProfileSaveStateNotifier(),
);

final formProfileSaveState = Provider((ref) {
  return ref.watch(formProfileSaveStateNotifierProvider);
});

final setFormProfileSaveState = Provider((ref) {
  return ref.read(formProfileSaveStateNotifierProvider.notifier).setState;
});
