import 'package:flutter/material.dart';

/// Color constants for the application.
class AppColor {
  /// Light gray color. Value: Color(0xFFDCDCDC).
  static const Color lightGray = Color(0xFFDCDCDC);

  /// Moderate gray color. Value: Color(0xFF727272).
  static const Color moderateGray = Color(0xFF727272);

  /// Heavy gray color. Value: Color(0xFF323232).
  static const Color heavyGray = Color(0xFF323232);

  /// Light blue color. Value: Color(0xFF82BAEC).
  static const Color lightBlue = Color(0xFF82BAEC);

  /// Heavy blue color. Value: Color(0xFF0E6CC0).
  static const Color heavyBlue = Color(0xFF0E6CC0);

  /// Light red color. Value: Color(0xFFFF6D60).
  static const Color lightRed = Color(0xFFFEEFEC);

  /// Heavy red color. Value: Color(0xFFEE002C).
  static const Color heavyRed = Color(0xFFFF2400);

  /// Light yellow color. Value: Color(0xFFFFFC8C).
  static const Color lightYellow = Color(0xFFFFFC8C);

  /// Heavy yellow color. Value: Color(0xFFF7DE2A).
  static const Color heavyYellow = Color(0xFFF7DE2A);

  /// Light green color. Value: Color(0xFFBEEEA6).
  static const Color lightGreen = Color(0xFFBEEEA6);

  /// Heavy green color. Value: Color(0xFF229800).
  static const Color heavyGreen = Color(0xFF229800);

  /// Primary color of the app. Value: Color(0xFFBF8450).
  static const Color primary = Color(0xFFBF8450);
}

/// Shadow constants for the application.
class Shadow {
  /// Medium shadow style.
  static BoxShadow medium = BoxShadow(
    color: Colors.grey.withOpacity(0.4),
    blurRadius: 16,
    spreadRadius: 2,
  );

  /// Small shadow style.
  static BoxShadow small = BoxShadow(
    color: Colors.grey.withOpacity(0.4),
    blurRadius: 2,
  );
}

/// Font family used in the app. Value: 'Mukta'.
const String appFontFamily = 'Mukta';

/// Text size constants for the application.
class TextSize {
  /// Very small text size. Value: 10.0.
  static const double verySmall = 10.0;

  /// Small text size. Value: 12.0.
  static const double small = 12.0;

  /// Medium text size. Value: 14.0.
  static const double medium = 14.0;

  /// Large text size. Value: 18.0.
  static const double large = 18.0;

  /// Very large text size. Value: 48.0.
  static const double veryLarge = 48.0;
}

/// Icon size constants for the application.
class IconSize {
  /// Small icon size. Value: 8.0.
  static const double small = 8.0;

  /// Medium icon size. Value: 24.0.
  static const double medium = 24.0;

  /// Large icon size. Value: 48.0.
  static const double large = 48.0;
}

/// Side size constants for the application.
class SideSize {
  /// Zero side size. Value: 0.0.
  static const double zero = 0.0;

  /// Very small side size. Value: 16.0.
  static const double verySmall = 16.0;

  /// Small side size. Value: 32.0.
  static const double small = 32.0;

  /// Medium side size. Value: 64.0.
  static const double medium = 64.0;

  /// Large side size. Value: 128.0.
  static const double large = 128.0;

  /// Very large side size. Value: 240.0.
  static const double veryLarge = 240.0;

  /// Infinity side size. Value: double.infinity.
  static const double infinity = double.infinity;
}

/// Padding size constants for the application.
class PaddingSize {
  /// Zero padding size. Value: 0.0.
  static const double zero = 0.0;

  /// Very small padding size. Value: 8.0.
  static const double verySmall = 8.0;

  /// Small padding size. Value: 16.0.
  static const double small = 16.0;

  /// Medium padding size. Value: 24.0.
  static const double medium = 24.0;

  /// Large padding size. Value: 32.0.
  static const double large = 32.0;

  /// Very large padding size. Value: 48.0.
  static const double veryLarge = 48.0;
}

/// Margin size constants for the application.
class MarginSize {
  /// Zero margin size. Value: 0.0.
  static const double zero = 0.0;

  /// Very small margin size. Value: 2.0.
  static const double verySmall = 2.0;

  /// Small margin size. Value: 4.0.
  static const double small = 4.0;

  /// Medium margin size. Value: 8.0.
  static const double medium = 8.0;

  /// Large margin size. Value: 12.0.
  static const double large = 12.0;

  /// Very large margin size. Value: 16.0.
  static const double veryLarge = 16.0;
}

/// Thickness size constants for the application.
class ThicknessSize {
  /// Very small thickness size. Value: 0.12.
  static const double verySmall = 0.12;

  /// Small thickness size. Value: 1.0.
  static const double small = 1.0;

  /// Medium thickness size. Value: 1.6.
  static const double medium = 1.6;

  /// Large thickness size. Value: 2.0.
  static const double large = 2.0;

  /// Very large thickness size. Value: 4.0.
  static const double veryLarge = 4.0;
}

/// Curvature size constants for the application.
class CurvatureSize {
  /// Small curvature size. Value: 8.0.
  static const double small = 8.0;

  /// Medium curvature size. Value: 12.0.
  static const double medium = 12.0;

  /// Large curvature size. Value: 16.0.
  static const double large = 16.0;

  /// Infinity curvature size. Value: double.infinity.
  static const double infinity = 1024.0;
}

/// Elevation size constants for the application.
class ElevationSize {
  /// Small elevation size. Value: 1.6.
  static const double small = 1.6;

  /// Large elevation size. Value: 2.0.
  static const double large = 2.0;
}

/// Animation duration constants for the application.
class AnimationDuration {
  /// Instant animation duration. Value: 0.
  static const int instant = 0;

  /// Quick animation duration. Value: 100.
  static const int quick = 100;

  /// Medium animation duration. Value: 320.
  static const int medium = 320;

  /// Slow animation duration. Value: 1200.
  static const int slow = 1200;
}

/// White space size constants for the application.
class WhiteSpaceSize {
  /// Very small white space size. Value: 8.0.
  static const double verySmall = 8.0;

  /// Small white space size. Value: 24.0.
  static const double small = 24.0;

  /// Medium white space size. Value: 32.0.
  static const double medium = 32.0;

  /// Large white space size. Value: 48.0.
  static const double large = 48.0;

  /// Very large white space size. Value: 80.0.
  static const double veryLarge = 80.0;
}
