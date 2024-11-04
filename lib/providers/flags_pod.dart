// ignore_for_file: camel_case_types

import 'package:flutter_riverpod/flutter_riverpod.dart';

class _FlagNotifier extends StateNotifier<bool> {
  _FlagNotifier(bool flag) : super(flag);

  void setState(bool flag) => state = flag;

  void toggleState() => state = !state;
}

typedef _flagPod = StateNotifierProvider<_FlagNotifier, bool>;

_flagPod _createFlagPod(bool flag) {
  return _flagPod((ref) => _FlagNotifier(flag));
}

final _authFlagPod = //
    _createFlagPod(false);
final _profileSaveFlagPod = //
    _createFlagPod(true);
final _loadingPhotoFlagPod = //
    _createFlagPod(false);

final isAuthenticated = //
    Provider((ref) => ref.watch(_authFlagPod));
final isProfileSaved = //
    Provider((ref) => ref.watch(_profileSaveFlagPod));
final isLoadingPhoto = //
    Provider((ref) => ref.watch(_loadingPhotoFlagPod));

final setAuthFlag = //
    Provider((ref) => ref.read(_authFlagPod.notifier).setState);
final setProfileSaveFlag =
    Provider((ref) => ref.read(_profileSaveFlagPod.notifier).setState);
final setLoadingPhotoFlag =
    Provider((ref) => ref.read(_loadingPhotoFlagPod.notifier).setState);
