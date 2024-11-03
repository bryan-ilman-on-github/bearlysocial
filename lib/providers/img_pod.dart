import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img_lib;

class _ImageNotifier extends StateNotifier<img_lib.Image?> {
  _ImageNotifier() : super(null);

  void setState(img) => state = img;
}

final _photoPod = StateNotifierProvider<_ImageNotifier, img_lib.Image?>(
  (ref) => _ImageNotifier(),
);

final photo = Provider((ref) => ref.watch(_photoPod));

final setPhoto = Provider((ref) => ref.read(_photoPod.notifier).setState);
