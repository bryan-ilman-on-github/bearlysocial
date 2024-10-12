import 'package:bearlysocial/components/form_elements/underlined_txt_field.dart';
import 'package:bearlysocial/providers/form_fields/foci_pod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirstNameTextField extends ConsumerWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const FirstName({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context, var ref) {
    ref.watch(firstNameFocusState);

    return UnderlinedTextField(
      label: 'First Name',
      controller: controller,
      focusNode: focusNode,
    );
  }
}
