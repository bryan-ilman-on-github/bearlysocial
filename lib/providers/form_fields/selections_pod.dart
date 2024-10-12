import 'package:flutter_riverpod/flutter_riverpod.dart';

class _SelectionNotifier extends StateNotifier<List<String>> {
  _SelectionNotifier() : super(<String>[]);

  void setState(List<String> items) => state = List<String>.from(items);

  void addItem(String item) {
    if (!state.contains(item)) state = List<String>.from(state)..add(item);
  }

  void rmvFirstItem() => state = List<String>.from(state)..removeAt(0);

  void rmvItem(String item) => state = List<String>.from(state)..remove(item);
}

final _interestsPod = StateNotifierProvider<_SelectionNotifier, List<String>>(
  (ref) => _SelectionNotifier(),
);

final interests = Provider((ref) => ref.watch(_interestsPod));

final setInterests =
    Provider((ref) => ref.read(_interestsPod.notifier).setState);

final addInterest = Provider((ref) => ref.read(_interestsPod.notifier).addItem);

final rmvFirstInterest =
    Provider((ref) => ref.read(_interestsPod.notifier).rmvFirstItem);

final rmvInterest = Provider((ref) => ref.read(_interestsPod.notifier).rmvItem);

final _langsPod = StateNotifierProvider<_SelectionNotifier, List<String>>(
  (ref) => _SelectionNotifier(),
);

final langs = Provider((ref) => ref.watch(_langsPod));

final setLangs = Provider((ref) => ref.read(_langsPod.notifier).setState);

final addLang = Provider((ref) => ref.read(_langsPod.notifier).addItem);

final rmvFirstLang =
    Provider((ref) => ref.read(_langsPod.notifier).rmvFirstItem);

final rmvLang = Provider((ref) => ref.read(_langsPod.notifier).rmvItem);
