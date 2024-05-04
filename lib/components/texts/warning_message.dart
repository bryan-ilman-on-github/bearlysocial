import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/providers/form_fields/form_profile_save_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WarningMessage extends ConsumerWidget {
  const WarningMessage({super.key});

  @override
  Widget build(BuildContext context, var ref) {
    return Text(
      ref.watch(formProfileSaveState) ? '' : 'changes not saved',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: TextSize.medium,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2,
            wordSpacing: 0.2,
          ),
    );
  }
}
