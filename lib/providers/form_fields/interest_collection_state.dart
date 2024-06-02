import 'package:flutter_riverpod/flutter_riverpod.dart';

class InterestCollectionStateNotifier extends StateNotifier<List<String>> {
  InterestCollectionStateNotifier() : super(<String>[]);

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

final interestCollectionStateNotifierProvider =
    StateNotifierProvider<InterestCollectionStateNotifier, List<String>>(
  (ref) => InterestCollectionStateNotifier(),
);

final interestCollection = Provider((ref) {
  return ref.watch(interestCollectionStateNotifierProvider);
});

final setInterestCollection = Provider((ref) {
  return ref
      .read(interestCollectionStateNotifierProvider.notifier)
      .setCollection;
});

final removeFirstLabelFromInterestCollection = Provider((ref) {
  return ref
      .read(interestCollectionStateNotifierProvider.notifier)
      .removeFirstLabel;
});

final addLabelToInterestCollection = Provider((ref) {
  return ref.read(interestCollectionStateNotifierProvider.notifier).addLabel;
});

final removeLabelFromInterestCollection = Provider((ref) {
  return ref.read(interestCollectionStateNotifierProvider.notifier).removeLabel;
});
