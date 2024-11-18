import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';

class ConnectivityUtility {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static OverlayEntry? warning;

  static void showBanner() {
    if (warning != null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey.currentState?.overlay == null) return;

      warning = OverlayEntry(
        builder: (context) => Positioned(
          top: 12.0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).focusColor.withAlpha(180),
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(CurvatureSize.large),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  const SizedBox(width: 8.0),
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
    });
  }

  static void hideBanner() {
    warning?.remove();
    warning = null;
  }
}
