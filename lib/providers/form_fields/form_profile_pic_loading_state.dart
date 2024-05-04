import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormProfilePictureLoadingStateNotifier extends StateNotifier<bool> {
  FormProfilePictureLoadingStateNotifier() : super(false);

  void setState({
    required bool newBool,
  }) {
    state = newBool;
  }
}

final formProfilePictureLoadingStateNotifierProvider =
    StateNotifierProvider<FormProfilePictureLoadingStateNotifier, bool>(
  (ref) => FormProfilePictureLoadingStateNotifier(),
);

final formProfilePicLoadingState = Provider((ref) {
  return ref.watch(formProfilePictureLoadingStateNotifierProvider);
});

final setFormProfilePicLoadingState = Provider((ref) {
  return ref
      .read(formProfilePictureLoadingStateNotifierProvider.notifier)
      .setState;
});
