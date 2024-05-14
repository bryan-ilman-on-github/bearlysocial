import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileSaveStateNotifier extends StateNotifier<bool> {
  ProfileSaveStateNotifier() : super(true);

  void setState({
    required bool isProfileSaved,
  }) {
    state = isProfileSaved;
  }
}

final profileSaveStateNotifierProvider =
    StateNotifierProvider<ProfileSaveStateNotifier, bool>(
  (ref) => ProfileSaveStateNotifier(),
);

final profileSaveState = Provider((ref) {
  return ref.watch(profileSaveStateNotifierProvider);
});

final setProfileSaveState = Provider((ref) {
  return ref.read(profileSaveStateNotifierProvider.notifier).setState;
});
