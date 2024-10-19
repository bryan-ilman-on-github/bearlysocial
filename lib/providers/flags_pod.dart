// ignore_for_file: camel_case_types

import 'package:flutter_riverpod/flutter_riverpod.dart';

class _FlagNotifier extends StateNotifier<bool> {
  _FlagNotifier(bool initFlag) : super(initFlag);

  void setState(bool activeFlag) => state = activeFlag;
}

typedef _flagPod = StateNotifierProvider<_FlagNotifier, bool>;

_flagPod _initFlagPod(bool initFlag) {
  return _flagPod((ref) => _FlagNotifier(initFlag));
}

final _authFlagPod = _initFlagPod(false);
final _profileSaveFlagPod = _initFlagPod(true);
final _profilePicLoadingFlagPod = _initFlagPod(false);

final isAuthenticated = //
    Provider((ref) => ref.watch(_authFlagPod));
final isProfileSaved = //
    Provider((ref) => ref.watch(_profileSaveFlagPod));
final isLoadingProfilePic =
    Provider((ref) => ref.watch(_profilePicLoadingFlagPod));

final setAuthFlag = //
    Provider((ref) => ref.read(_authFlagPod.notifier).setState);
final setProfileSaveFlag =
    Provider((ref) => ref.read(_profileSaveFlagPod.notifier).setState);
final setLoadingProfilePicFlag =
    Provider((ref) => ref.read(_profilePicLoadingFlagPod.notifier).setState);
