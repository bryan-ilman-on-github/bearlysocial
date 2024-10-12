import 'package:flutter_riverpod/flutter_riverpod.dart';

class _FlagNotifier extends StateNotifier<bool> {
  _FlagNotifier(bool initVal) : super(initVal);

  void setState(bool newVal) => state = newVal;
}

final _profileSaveFlagPod = StateNotifierProvider<_FlagNotifier, bool>(
  (ref) => _FlagNotifier(true),
);
final _profilePicLoadingFlagPod = StateNotifierProvider<_FlagNotifier, bool>(
  (ref) => _FlagNotifier(false),
);

final isProfileSaved = Provider((ref) => ref.watch(_profileSaveFlagPod));
final isLoadingProfilePic =
    Provider((ref) => ref.watch(_profilePicLoadingFlagPod));

final setProfileSaveFlag =
    Provider((ref) => ref.read(_profileSaveFlagPod.notifier).setState);
final setProfilePicLoadingFlag =
    Provider((ref) => ref.read(_profilePicLoadingFlagPod.notifier).setState);
