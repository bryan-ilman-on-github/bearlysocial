import 'package:bearlysocial/components/form_elements/underlined_txt_field.dart';
import 'package:bearlysocial/providers/form_fields/foci_pod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LastNameTextField extends ConsumerWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const LastNameTextField({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context, var ref) {
    ref.watch(lastNameFocus);

    return UnderlinedTextField(
      label: 'Last Name',
      controller: controller,
      focusNode: focusNode,
    );
  }
}
