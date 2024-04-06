import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';

Color? _backgroundColor;
Color? _highlightColor;
Color? _normalColor;
Color? _focusColor;
Color? _indicatorColor;

ThemeData createTheme({required bool lightMode}) {
  _backgroundColor = lightMode ? Colors.white : AppColor.heavyGray;
  _highlightColor = lightMode ? AppColor.lightGray : AppColor.moderateGray;
  _normalColor = lightMode ? AppColor.moderateGray : AppColor.lightGray;
  _focusColor = lightMode ? AppColor.heavyGray : Colors.white;

  _indicatorColor = lightMode ? AppColor.heavyBlue : AppColor.lightBlue;

  return ThemeData(
    primaryColor: AppColor.primary,
    scaffoldBackgroundColor: _backgroundColor,
    dividerColor: _normalColor,
    focusColor: _focusColor,
    highlightColor: _highlightColor,
    indicatorColor: _indicatorColor,
    textTheme: _textTheme,
    iconTheme: _iconTheme,
    dropdownMenuTheme: _dropdownMenuTheme,
    splashFactory: InkRipple.splashFactory,
  );
}

TextTheme get _textTheme {
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

TextStyle get _bodyMedium {
  return TextStyle(
    overflow: TextOverflow.ellipsis,
    fontFamily: appFontFamily,
    fontSize: TextSize.medium,
    fontWeight: FontWeight.normal,
    color: _normalColor,
    letterSpacing: 0.4,
  );
}

IconThemeData get _iconTheme {
  return IconThemeData(
    size: IconSize.medium,
    color: _normalColor,
  );
}

DropdownMenuThemeData get _dropdownMenuTheme {
  return DropdownMenuThemeData(
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: _bodyMedium,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          CurvatureSize.large,
        ),
        borderSide: BorderSide(
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
      elevation: const MaterialStatePropertyAll(
        ElevationSize.large,
      ),
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
      maximumSize: const MaterialStatePropertyAll(
        Size(
          double.infinity,
          SideSize.veryLarge,
        ),
      ),
    ),
  );
}
