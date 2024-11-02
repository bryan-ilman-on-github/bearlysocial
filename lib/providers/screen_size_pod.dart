import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class _SizeNotifier extends StateNotifier<Size> {
  _SizeNotifier() : super(const Size(0, 0));

  void setState(size) => state = size;
}

final _screenSizePod = StateNotifierProvider<_SizeNotifier, Size>(
  (ref) => _SizeNotifier(),
);

final screenSize = Provider((ref) => ref.watch(_screenSizePod));

final setScreenSize =
    Provider((ref) => ref.read(_screenSizePod.notifier).setState);
