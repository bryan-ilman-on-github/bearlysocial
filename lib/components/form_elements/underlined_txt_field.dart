import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UnderlinedTextField extends StatefulWidget {
  final bool enabled;
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? errorText;

  const UnderlinedTextField({
    super.key,
    this.enabled = true,
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
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      controller: widget.controller,
      style: Theme.of(context).textTheme.bodyMedium,
      inputFormatters: [
        LengthLimitingTextInputFormatter(320),
        FilteringTextInputFormatter.allow(
          RegExp(r'[a-zA-Z0-9@_.]'),
        ),
      ],
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
        errorMaxLines: 4,
        errorStyle: Theme.of(context).textTheme.bodySmall,
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColor.heavyRed,
            width: ThicknessSize.medium,
          ),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColor.heavyRed,
            width: ThicknessSize.large,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).dividerColor,
            width: ThicknessSize.medium,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).focusColor,
            width: ThicknessSize.large,
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
