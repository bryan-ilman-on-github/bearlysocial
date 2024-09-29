import 'package:bearlysocial/components/form_elements/dropdown.dart';
import 'package:bearlysocial/providers/form_fields/interest_collection_state.dart';
import 'package:bearlysocial/utils/dropdown_operation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InterestCollection extends ConsumerWidget {
  final TextEditingController controller;
  final void Function() addLabel;
  final void Function({required String labelToRemove}) removeLabel;

  const InterestCollectionDropdown({
    super.key,
    required this.controller,
    required this.addLabel,
    required this.removeLabel,
  });

  @override
  Widget build(BuildContext context, var ref) {
    return Dropdown(
      hint: 'Interest(s)',
      controller: controller,
      menu: DropdownOperation.buildMenu(
        entries: DropdownOperation.allInterests,
      ),
      collection: ref.watch(interestCollection),
      addLabel: addLabel,
      removeLabel: removeLabel,
    );
  }
}
