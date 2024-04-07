import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';

class UnderlinedTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? errorText;

  /// [UnderlinedTextField] is a [StatefulWidget] representing a text input field with an underline.
  const UnderlinedTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.focusNode,
    this.errorText,
  });
  @override
  State<UnderlinedTextField> createState() => _UnderlinedTextFieldState();
}

class _UnderlinedTextFieldState extends State<UnderlinedTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              height: 0.8,
              fontWeight: widget.focusNode.hasFocus
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: widget.focusNode.hasFocus
                  ? Theme.of(context).textTheme.titleLarge?.color
                  : Theme.of(context).textTheme.bodyMedium?.color,
            ),
        errorText: widget.errorText,
        errorMaxLines: 2,
        errorStyle: Theme.of(context).textTheme.bodySmall,
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColor.heavyRed,
            width: ThicknessSize.small,
          ),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColor.heavyRed,
            width: ThicknessSize.medium,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).dividerColor,
            width: ThicknessSize.small,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).focusColor,
            width: ThicknessSize.medium,
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
