import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/views/buttons/splash_btn.dart';
import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  final double? top;
  final double? right;

  const CancelButton({
    super.key,
    this.top,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      child: UnconstrainedBox(
        child: SplashButton(
          horizontalPadding: PaddingSize.verySmall,
          verticalPadding: PaddingSize.verySmall,
          buttonColor: Colors.white,
          borderRadius: BorderRadius.circular(
            CurvatureSize.infinity,
          ),
          callbackFunction: () => Navigator.pop(context),
          child: const Icon(
            Icons.close_rounded,
            color: AppColor.heavyGray,
          ),
        ),
      ),
    );
  }
}
