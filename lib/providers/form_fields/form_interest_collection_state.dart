import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormInterestCollectionStateNotifier extends StateNotifier<List<String>> {
  FormInterestCollectionStateNotifier() : super(<String>[]);

  void setState({
    required List<String> state,
  }) {
    state = state;
  }
}

final formInterestCollectionStateNotifierProvider =
    StateNotifierProvider<FormInterestCollectionStateNotifier, List<String>>(
  (ref) => FormInterestCollectionStateNotifier(),
);

final formInterestCollection = Provider((ref) {
  return ref.watch(formInterestCollectionStateNotifierProvider);
});

final setFormInterestCollection = Provider((ref) {
  return ref
      .read(formInterestCollectionStateNotifierProvider.notifier)
      .setState;
});
