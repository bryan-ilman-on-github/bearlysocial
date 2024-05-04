import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';

class ProgressSpinner extends StatelessWidget {
  const ProgressSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SideSize.verySmall,
      height: SideSize.verySmall,
      child: CircularProgressIndicator(
        strokeWidth: ThicknessSize.large,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
