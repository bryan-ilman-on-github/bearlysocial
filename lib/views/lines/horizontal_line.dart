import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';

class HorizontalLine extends StatelessWidget {
  final double width;
  final double height;
  final double horizontalMargin;
  final double verticalMargin;
  final Color? color;

  /// [HorizontalLine] is a [StatelessWidget] representing a horizontal line.
  const HorizontalLine({
    super.key,
    this.width = SideSize.infinity,
    this.height = ThicknessSize.verySmall,
    this.horizontalMargin = MarginSize.zero,
    this.verticalMargin = MarginSize.zero,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontalMargin,
        vertical: verticalMargin,
      ),
      width: width,
      height: height,
      color: color ?? Theme.of(context).focusColor,
    );
  }
}
