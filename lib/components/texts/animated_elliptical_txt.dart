import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';

class AnimatedEllipticalText extends StatelessWidget {
  final AnimationController controller;
  final String leadingText;
  final TextStyle? textStyle;

  const AnimatedEllipticalText({
    super.key,
    required this.controller,
    required this.leadingText,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Text(
          '$leadingText ',
          style: textStyle,
        ),
        Expanded(
          child: Row(
            children: [
              ...List.generate(
                4,
                (index) => AnimatedOpacity(
                  opacity: controller.value > index * 0.25 ? 1.0 : 0.0,
                  duration: const Duration(
                    milliseconds: AnimationDuration.instant,
                  ),
                  child: Text(
                    '.',
                    style: textStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
