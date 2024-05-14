import 'package:flutter_riverpod/flutter_riverpod.dart';

class InterestCollectionStateNotifier extends StateNotifier<List<String>> {
  InterestCollectionStateNotifier() : super(<String>[]);

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
