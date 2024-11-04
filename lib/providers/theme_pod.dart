import 'package:bearlysocial/constants/db_key.dart';
import 'package:bearlysocial/utils/local_db_util.dart';
import 'package:bearlysocial/utils/theme_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

bool _darkModeEnabled = LocalDatabaseUtility.retrieveTransaction(
      key: DatabaseKey.darkModeEnabled.name,
    ) ==
    true.toString();

class _ThemeNotifier extends StateNotifier<ThemeData> {
  _ThemeNotifier(ThemeData theme) : super(theme);

  void toggleState() {
    _darkModeEnabled = !_darkModeEnabled;

    LocalDatabaseUtility.insertTransaction(
      key: DatabaseKey.darkModeEnabled.name,
      value: _darkModeEnabled.toString(),
    );

    state = ThemeUtility.createTheme(_darkModeEnabled);
  }
}

final _pod = StateNotifierProvider<_ThemeNotifier, ThemeData>(
  (ref) => _ThemeNotifier(ThemeUtility.createTheme(_darkModeEnabled)),
);

final theme = Provider((ref) => ref.watch(_pod));

final toggleTheme = Provider((ref) => ref.read(_pod.notifier).toggleState);
