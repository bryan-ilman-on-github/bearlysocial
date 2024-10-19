import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img_lib;

class _ProfilePicNotifier extends StateNotifier<img_lib.Image?> {
  _ProfilePicNotifier() : super(null);

  void setState(img_lib.Image? img) => state = img;
}

final _pod = StateNotifierProvider<_ProfilePicNotifier, img_lib.Image?>(
  (ref) => _ProfilePicNotifier(),
);

final profilePic = Provider((ref) => ref.watch(_pod));

final setProfilePic = Provider((ref) => ref.read(_pod.notifier).setState);
