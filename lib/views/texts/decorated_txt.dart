import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';

class DecoratedText extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final double? textSize;
  final double paddingSize;

  const DecoratedText({
    super.key,
    required this.text,
    required this.backgroundColor,
    this.textSize,
    this.paddingSize = PaddingSize.verySmall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        paddingSize,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          CurvatureSize.small,
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: textSize,
            ),
      ),
    );
  }
}
