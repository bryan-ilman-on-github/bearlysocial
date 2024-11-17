import 'package:bearlysocial/providers/statuses_pod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WarningMessage extends ConsumerWidget {
  const WarningMessage({super.key});

  @override
  Widget build(context, ref) {
    return Text(
      ref.watch(isProfileSaved) ? '' : 'Changes not saved yet.',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            letterSpacing: 0.0,
            wordSpacing: 0.0,
          ),
    );
  }
}
