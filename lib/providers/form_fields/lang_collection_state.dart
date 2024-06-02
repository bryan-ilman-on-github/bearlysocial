import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageCollectionStateNotifier extends StateNotifier<List<String>> {
  LanguageCollectionStateNotifier() : super(<String>[]);

  void setCollection({
    required List<String> collection,
  }) {
    state = List<String>.from(collection);
  }

  void removeFirstLabel() {
    state = List<String>.from(state)..removeAt(0);
  }

  void addLabel({required String label}) {
    if (!state.contains(label)) state = List<String>.from(state)..add(label);
  }

  void removeLabel({required String labelToRemove}) {
    state = List<String>.from(state)..remove(labelToRemove);
  }
}

final langCollectionStateNotifierProvider =
    StateNotifierProvider<LanguageCollectionStateNotifier, List<String>>(
  (ref) => LanguageCollectionStateNotifier(),
);

final langCollection = Provider((ref) {
  return ref.watch(langCollectionStateNotifierProvider);
});

final setLangCollection = Provider((ref) {
  return ref.read(langCollectionStateNotifierProvider.notifier).setCollection;
});

final removeFirstLabelFromLangCollection = Provider((ref) {
  return ref
      .read(langCollectionStateNotifierProvider.notifier)
      .removeFirstLabel;
});

final addLabelToLangCollection = Provider((ref) {
  return ref.read(langCollectionStateNotifierProvider.notifier).addLabel;
});

final removeLabelFromLangCollection = Provider((ref) {
  return ref.read(langCollectionStateNotifierProvider.notifier).removeLabel;
});
