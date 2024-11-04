import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

Size getDeviceSize() {
  final physicalSize = PlatformDispatcher.instance.views.first.physicalSize;
  final devicePixelRatio =
      PlatformDispatcher.instance.views.first.devicePixelRatio;
  return Size(
    physicalSize.width / devicePixelRatio,
    physicalSize.height / devicePixelRatio,
  );
}

class _ScreenSizeNotifier extends StateNotifier<Size> {
  _ScreenSizeNotifier() : super(getDeviceSize());

  void setState(screenSize) => state = screenSize;
}

final _pod = StateNotifierProvider<_ScreenSizeNotifier, Size>(
  (ref) => _ScreenSizeNotifier(),
);

final screenSize = Provider((ref) => ref.watch(_pod));

final setScreenSize = Provider((ref) => ref.read(_pod.notifier).setState);
