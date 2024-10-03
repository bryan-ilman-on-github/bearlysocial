import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img_lib;

class ProfilePictureStateNotifier extends StateNotifier<img_lib.Image?> {
  ProfilePictureStateNotifier() : super(null);

  void setPic({
    required img_lib.Image? pic,
  }) {
    state = pic;
  }
}

final profilePicStateNotifierProvider =
    StateNotifierProvider<ProfilePictureStateNotifier, img_lib.Image?>(
  (ref) => ProfilePictureStateNotifier(),
);

final profilePic = Provider((ref) {
  return ref.watch(profilePicStateNotifierProvider);
});

final setProfilePic = Provider((ref) {
  return ref.read(profilePicStateNotifierProvider.notifier).setPic;
});
