import 'package:flutter_riverpod/flutter_riverpod.dart';

class _SelectionNotifier extends StateNotifier<List<String>> {
  _SelectionNotifier() : super(<String>[]);

  void setState(List<String> items) => state = items;

  void addItem(String item) {
    if (!state.contains(item)) state = List<String>.from(state)..add(item);
  }

  void removeFirstItem() => state = List<String>.from(state)..removeAt(0);

  void removeItem(String item) => state = List<String>.from(state) //
    ..remove(item);
}

final _langsPod = StateNotifierProvider<_SelectionNotifier, List<String>>(
  (ref) => _SelectionNotifier(),
);
final _interestsPod = StateNotifierProvider<_SelectionNotifier, List<String>>(
  (ref) => _SelectionNotifier(),
);

final langs = Provider((ref) => ref.watch(_langsPod));
final interests = Provider((ref) => ref.watch(_interestsPod));

final setLangs = //
    Provider((ref) => ref.read(_langsPod.notifier).setState);
final setInterests =
    Provider((ref) => ref.read(_interestsPod.notifier).setState);

final addLang = Provider((ref) => ref.read(_langsPod.notifier).addItem);
final addInterest = Provider((ref) => ref.read(_interestsPod.notifier).addItem);

final removeFirstLang =
    Provider((ref) => ref.read(_langsPod.notifier).removeFirstItem);
final removeFirstInterest =
    Provider((ref) => ref.read(_interestsPod.notifier).removeFirstItem);

final removeLang = //
    Provider((ref) => ref.read(_langsPod.notifier).removeItem);
final removeInterest =
    Provider((ref) => ref.read(_interestsPod.notifier).removeItem);
