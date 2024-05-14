import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageCollectionStateNotifier extends StateNotifier<List<String>> {
  LanguageCollectionStateNotifier() : super(<String>[]);

  void setCollection({
    required List<String> collection,
  }) {
    state = collection;
  }

  void removeFirstLabel() {
    state.removeAt(0);
  }

  void addLabel({required String label}) {
    state.add(label);
  }

  void removeLabel({required String labelToRemove}) {
    state.remove(labelToRemove);
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
