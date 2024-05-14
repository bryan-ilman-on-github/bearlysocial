import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePictureLoadingStateNotifier extends StateNotifier<bool> {
  ProfilePictureLoadingStateNotifier() : super(false);

  void setState({
    required bool isProfilePicBeingLoaded,
  }) {
    state = isProfilePicBeingLoaded;
  }
}

final profilePicLoadingNotifierProvider =
    StateNotifierProvider<ProfilePictureLoadingStateNotifier, bool>(
  (ref) => ProfilePictureLoadingStateNotifier(),
);

final profilePicLoadingState = Provider((ref) {
  return ref.watch(profilePicLoadingNotifierProvider);
});

final setProfilePicLoadingState = Provider((ref) {
  return ref.read(profilePicLoadingNotifierProvider.notifier).setState;
});
