import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetBannerOverlay {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static OverlayEntry? overlayEntry;

  static void showBanner() {
    if (overlayEntry != null) return;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            color: Colors.black.withOpacity(0.8),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: const [
                Icon(Icons.warning, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "No internet connection",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    navigatorKey.currentState?.overlay?.insert(overlayEntry!);
  }

  static void hideBanner() {
    overlayEntry?.remove();
    overlayEntry = null;
  }
}
