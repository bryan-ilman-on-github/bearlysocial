import 'package:bearlysocial/components/form_elements/dropdown.dart';
import 'package:bearlysocial/constants/native_lang_name.dart';
import 'package:bearlysocial/providers/form_fields/lang_collection_state.dart';
import 'package:bearlysocial/utilities/dropdown_operation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageCollection extends ConsumerWidget {
  final TextEditingController controller;
  final void Function() addLabel;
  final void Function({required String labelToRemove}) removeLabel;

  const LanguageCollection({
    super.key,
    required this.controller,
    required this.addLabel,
    required this.removeLabel,
  });

  @override
  Widget build(BuildContext context, var ref) {
    return Dropdown(
      hint: 'Language(s)',
      controller: controller,
      menu: DropdownOperation.buildMenu(
        entries: NativeLanguageName.map,
      ),
      collection: ref.watch(langCollection),
      addLabel: addLabel,
      removeLabel: removeLabel,
    );
  }
}
