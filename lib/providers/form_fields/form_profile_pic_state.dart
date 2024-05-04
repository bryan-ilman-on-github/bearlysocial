import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img_lib;

class FormProfilePictureStateNotifier extends StateNotifier<img_lib.Image?> {
  FormProfilePictureStateNotifier() : super(null);

  void setState({
    required img_lib.Image? newProfilePic,
  }) {
    state = newProfilePic;
  }
}

final formProfilePictureStateNotifierProvider =
    StateNotifierProvider<FormProfilePictureStateNotifier, img_lib.Image?>(
  (ref) => FormProfilePictureStateNotifier(),
);

final formProfilePic = Provider((ref) {
  return ref.watch(formProfilePictureStateNotifierProvider);
});

final setFormProfilePic = Provider((ref) {
  return ref.read(formProfilePictureStateNotifierProvider.notifier).setState;
});
