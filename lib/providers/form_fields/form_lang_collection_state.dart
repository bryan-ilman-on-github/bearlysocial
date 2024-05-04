import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormLanguageCollectionStateNotifier extends StateNotifier<List<String>> {
  FormLanguageCollectionStateNotifier() : super(<String>[]);

  void setState({
    required List<String> state,
  }) {
    state = state;
  }
}

final formlanguageCollectionStateNotifierProvider =
    StateNotifierProvider<FormLanguageCollectionStateNotifier, List<String>>(
  (ref) => FormLanguageCollectionStateNotifier(),
);

final formLangCollection = Provider((ref) {
  return ref.watch(formlanguageCollectionStateNotifierProvider);
});

final setFormLangCollection = Provider((ref) {
  return ref
      .read(formlanguageCollectionStateNotifierProvider.notifier)
      .setState;
});
