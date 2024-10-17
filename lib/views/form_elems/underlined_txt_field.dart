import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnderlinedTextField extends ConsumerStatefulWidget {
  final bool enabled;
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Provider<bool>? focusPod;
  final String? errorText;

  const UnderlinedTextField({
    super.key,
    this.enabled = true,
    required this.label,
    required this.controller,
    required this.focusNode,
    this.focusPod,
    this.errorText,
  });

  @override
  ConsumerState<UnderlinedTextField> createState() =>
      _UnderlinedTextFieldState();
}

class _UnderlinedTextFieldState extends ConsumerState<UnderlinedTextField> {
  @override
  Widget build(BuildContext context) {
    if (widget.focusPod is Provider<bool>) {
      ref.watch(widget.focusPod as Provider<bool>); // TODO: check this!
    }

    return TextField(
      enabled: widget.enabled,
      controller: widget.controller,
      focusNode: widget.focusNode,
      style: Theme.of(context).textTheme.bodyMedium,
      inputFormatters: [
        LengthLimitingTextInputFormatter(256),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@_.]')),
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
        errorMaxLines: 2,
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
