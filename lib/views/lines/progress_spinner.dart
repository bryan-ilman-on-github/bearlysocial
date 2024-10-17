import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';

class ProgressSpinner extends StatelessWidget {
  final bool invertColor;

  const ProgressSpinner({
    super.key,
    this.invertColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SideSize.verySmall,
      height: SideSize.verySmall,
      child: CircularProgressIndicator(
        strokeWidth: ThicknessSize.large,
        color: invertColor
            ? Theme.of(context).scaffoldBackgroundColor
            : Theme.of(context).dividerColor,
      ),
    );
  }
}
