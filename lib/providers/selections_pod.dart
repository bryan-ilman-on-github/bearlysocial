import 'package:flutter_riverpod/flutter_riverpod.dart';

class _SelectionNotifier extends StateNotifier<List<String>> {
  _SelectionNotifier() : super(<String>[]);

  void setState(List<String> entries) => state = entries;

  void addEntry(String entry) {
    if (!state.contains(entry)) state = List<String>.from(state)..add(entry);
  }

  void removeFirstEntry() => state = List<String>.from(state)..removeAt(0);

  void removeEntry(String entry) => state = List<String>.from(state) //
    ..remove(entry);
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

final addLang = //
    Provider((ref) => ref.read(_langsPod.notifier).addEntry);
final addInterest =
    Provider((ref) => ref.read(_interestsPod.notifier).addEntry);

final removeFirstLang =
    Provider((ref) => ref.read(_langsPod.notifier).removeFirstEntry);
final removeFirstInterest =
    Provider((ref) => ref.read(_interestsPod.notifier).removeFirstEntry);

final removeLang = //
    Provider((ref) => ref.read(_langsPod.notifier).removeEntry);
final removeInterest =
    Provider((ref) => ref.read(_interestsPod.notifier).removeEntry);
