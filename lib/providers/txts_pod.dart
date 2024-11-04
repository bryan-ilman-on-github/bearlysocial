import 'package:flutter_riverpod/flutter_riverpod.dart';

class _TextNotifier extends StateNotifier<String> {
  _TextNotifier() : super('');

  void setState(String text) => state = text;
}

final _emailAddrPod = StateNotifierProvider<_TextNotifier, String>(
  (ref) => _TextNotifier(),
);

final authEmailAddr = Provider((ref) => ref.watch(_emailAddrPod));

final setAuthEmailAddr =
    Provider((ref) => ref.read(_emailAddrPod.notifier).setState);
