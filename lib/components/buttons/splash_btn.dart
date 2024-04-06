import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';

class SplashButton extends StatelessWidget {
  final double? width;
  final double? height;
  final double? horizontalPadding;
  final double? verticalPadding;
  final Function()? callbackFunction;
  final Color? buttonColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final Color? splashColor;
  final BoxShadow? shadow;
  final Widget? child;

  /// [SplashButton] is a [StatelessWidget] representing a customizable button
  /// designed to provide a splash effect upon user interaction.
  /// It can be configured with various visual properties such as size, padding, colors, and shadows.
  const SplashButton({
    super.key,
    this.width,
    this.height,
    this.horizontalPadding,
    this.verticalPadding,
    this.callbackFunction,
    this.buttonColor,
    this.borderColor,
    this.borderRadius,
    this.splashColor,
    this.shadow,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.transparent,
        ),
        borderRadius: borderRadius ??
            BorderRadius.circular(
              CurvatureSize.large,
            ),
        boxShadow: [
          if (shadow != null) shadow!,
        ],
      ),
      child: Material(
        color: buttonColor ?? Theme.of(context).focusColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: borderColor ?? Colors.transparent,
          ),
          borderRadius: borderRadius ??
              BorderRadius.circular(
                CurvatureSize.large,
              ),
        ),
        child: InkWell(
          onTap: callbackFunction?.call,
          splashColor: splashColor,
          borderRadius: borderRadius ??
              BorderRadius.circular(
                CurvatureSize.large,
              ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding ?? PaddingSize.zero,
              vertical: verticalPadding ?? PaddingSize.zero,
            ),
            child: Center(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
