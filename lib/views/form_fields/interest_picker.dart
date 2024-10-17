import 'package:bearlysocial/components/form_elements/dropdown.dart';
import 'package:bearlysocial/providers/form_fields/selections_pod.dart';
import 'package:bearlysocial/utils/form_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InterestPicker extends ConsumerWidget {
  final TextEditingController controller;
  final void Function() addLabel;
  final void Function(String item) removeInterest;

  const InterestPicker({
    super.key,
    required this.controller,
    required this.addLabel,
    required this.removeInterest,
  });

  @override
  Widget build(BuildContext context, var ref) {
    return Dropdown(
      hint: 'Interest(s)',
      controller: controller,
      menu: FormUtility.buildDropdownMenu(
        entries: FormUtility.allInterests,
      ),
      collection: ref.watch(interests),
      addLabel: addLabel,
      removeLabel: removeInterest,
    );
  }
}
