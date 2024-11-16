import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';

late Color? //
    _backgroundColor,
    _highlightColor,
    _normalColor,
    _focusColor,
    _indicatorColor;

class ThemeUtility {
  static ThemeData createTheme({bool dark = false}) {
    _backgroundColor = //
        dark ? AppColor.heavyGray : Colors.white;
    _highlightColor = //
        dark ? AppColor.moderateGray : AppColor.lightGray;
    _normalColor = //
        dark ? AppColor.lightGray : AppColor.moderateGray;
    _focusColor = //
        dark ? Colors.white : AppColor.heavyGray;
    _indicatorColor = //
        dark ? AppColor.lightBlue : AppColor.heavyBlue;

    return ThemeData(
      primaryColor: AppColor.primary,
      scaffoldBackgroundColor: _backgroundColor,
      dividerColor: _normalColor,
      focusColor: _focusColor,
      highlightColor: _highlightColor,
      indicatorColor: _indicatorColor,
      textTheme: _textTheme,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: _focusColor,
        selectionColor: _highlightColor,
        selectionHandleColor: _focusColor,
      ),
      iconTheme: _iconTheme,
      dropdownMenuTheme: _dropdownMenuTheme,
      splashFactory: InkRipple.splashFactory,
    );
  }

  static TextStyle get _bodyMedium {
    return TextStyle(
      overflow: TextOverflow.ellipsis,
      fontFamily: fontFamily,
      fontSize: TextSize.medium,
      fontWeight: FontWeight.normal,
      color: _normalColor,
      letterSpacing: 0.4,
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: _bodyMedium.copyWith(
        fontSize: TextSize.veryLarge,
        fontWeight: FontWeight.bold,
        color: _focusColor,
      ),
      titleSmall: _bodyMedium.copyWith(
        fontSize: TextSize.small,
        fontWeight: FontWeight.bold,
        color: _focusColor,
      ),
      titleMedium: _bodyMedium.copyWith(
        fontSize: TextSize.medium,
        fontWeight: FontWeight.bold,
        color: _backgroundColor,
      ),
      titleLarge: _bodyMedium.copyWith(
        fontSize: TextSize.large,
        fontWeight: FontWeight.bold,
        color: _focusColor,
      ),
      bodySmall: _bodyMedium.copyWith(
        fontSize: TextSize.small,
        fontWeight: FontWeight.normal,
        color: AppColor.heavyRed,
      ),
      bodyMedium: _bodyMedium,
    );
  }

  static IconThemeData get _iconTheme {
    return IconThemeData(
      size: IconSize.medium,
      color: _normalColor,
    );
  }

  static DropdownMenuThemeData get _dropdownMenuTheme {
    return DropdownMenuThemeData(
      textStyle: _bodyMedium,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: _bodyMedium,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            CurvatureSize.large,
          ),
          borderSide: BorderSide(
            width: ThicknessSize.medium,
            color: _normalColor as Color,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            CurvatureSize.large,
          ),
          borderSide: BorderSide(
            width: ThicknessSize.large,
            color: _focusColor as Color,
          ),
        ),
      ),
      menuStyle: MenuStyle(
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              CurvatureSize.large,
            ),
            side: BorderSide(
              width: ThicknessSize.verySmall,
              color: _normalColor as Color,
            ),
          ),
        ),
        backgroundColor: const MaterialStatePropertyAll(
          Colors.white,
        ),
        surfaceTintColor: const MaterialStatePropertyAll(
          Colors.transparent,
        ),
        maximumSize: const MaterialStatePropertyAll(
          Size(
            double.infinity,
            SideSize.veryLarge,
          ),
        ),
        elevation: const MaterialStatePropertyAll(ElevationSize.large),
      ),
    );
  }
}
