import 'package:flutter_riverpod/flutter_riverpod.dart';

class _ListNotifier<T> extends StateNotifier<List<T>> {
  _ListNotifier() : super(<T>[]);

  void setState(List<T> entries) => state = entries;

  void addEntry(T entry) {
    if (!state.contains(entry)) state = List<T>.from(state)..add(entry);
  }

  void removeFirstEntry() => state = List<T>.from(state)..removeAt(0);

  void removeEntry(T entry) => state = List<T>.from(state)..remove(entry);
}

final _langsPod = //
    StateNotifierProvider<_ListNotifier<String>, List<String>>(
  (ref) => _ListNotifier<String>(),
);
final _interestsPod =
    StateNotifierProvider<_ListNotifier<String>, List<String>>(
  (ref) => _ListNotifier<String>(),
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
