import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';

class ConnectivityUtility {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static OverlayEntry? warning;

  static void showBanner() {
    if (warning != null) return;

    warning = OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        bottom: 52.0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.all(MarginSize.veryLarge),
            padding: const EdgeInsets.all(PaddingSize.verySmall),
            decoration: BoxDecoration(
              color: Theme.of(context).focusColor,
              border: Border.all(color: Colors.transparent),
              borderRadius: BorderRadius.circular(CurvatureSize.large),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_rounded,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                const SizedBox(width: WhiteSpaceSize.verySmall),
                Text(
                  "No internet connection.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    navigatorKey.currentState?.overlay?.insert(warning!);
  }

  static void hideBanner() {
    warning?.remove();
    warning = null;
  }
}
