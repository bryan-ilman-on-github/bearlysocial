import 'package:flutter_riverpod/flutter_riverpod.dart';

class _StatusNotifier extends StateNotifier<bool> {
  _StatusNotifier(bool status) : super(status);

  void setState(bool status) => state = status;
}

typedef StatusPod = StateNotifierProvider<_StatusNotifier, bool>;
StatusPod _createStatusPod(bool status) {
  return StatusPod((ref) => _StatusNotifier(status));
}

final _authStatusPod = //
    _createStatusPod(false);
final _profileSaveStatusPod = //
    _createStatusPod(true);
final _loadingPhotoStatusPod = //
    _createStatusPod(false);

final isAuthenticated = //
    Provider((ref) => ref.watch(_authStatusPod));
final isProfileSaved = //
    Provider((ref) => ref.watch(_profileSaveStatusPod));
final isLoadingPhoto = //
    Provider((ref) => ref.watch(_loadingPhotoStatusPod));

final setAuthStatus = //
    Provider((ref) => ref.read(_authStatusPod.notifier).setState);
final setProfileSaveStatus =
    Provider((ref) => ref.read(_profileSaveStatusPod.notifier).setState);
final setLoadingPhotoStatus =
    Provider((ref) => ref.read(_loadingPhotoStatusPod.notifier).setState);
