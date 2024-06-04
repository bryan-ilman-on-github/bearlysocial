import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class FormManagement {
  static bool validateEmailAddress({
    required String emailAddress,
  }) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );

    return emailRegExp.hasMatch(emailAddress);
  }

  static bool listsContainSameElements({
    required List<dynamic> listA,
    required List<dynamic> listB,
  }) {
    return Set.from(listA).difference(Set.from(listB)).isEmpty &&
        Set.from(listB).difference(Set.from(listA)).isEmpty;
  }

  static Color calculateRatingColor({
    required double rating,
  }) {
    const Color startColor = AppColor.heavyRed;
    const Color middleColor = AppColor.heavyYellow;
    const Color endColor = AppColor.heavyGreen;

    final double normalizedRating = (rating - 0.0) / (5.0 - 0.0);

    const double firstStop = 0.5;
    const double secondStop = 1.0;

    Color? ratingColor;

    if (normalizedRating <= firstStop) {
      ratingColor = Color.lerp(
        startColor,
        middleColor,
        normalizedRating / firstStop,
      );
    } else {
      ratingColor = Color.lerp(
        middleColor,
        endColor,
        (normalizedRating - firstStop) / (secondStop - firstStop),
      );
    }

    return ratingColor ?? Colors.transparent;
  }

  static Future<List<DateTime>?> appDateTimeRangePicker({
    required context,
  }) {
    return showOmniDateTimeRangePicker(
      context: context,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: AppColor.heavyGray,
          surface: Colors.transparent,
          onSurface: AppColor.heavyGray,
        ),
      ),
      is24HourMode: true,
      isForceEndDateAfterStartDate: true,
      startInitialDate: DateTime.now().add(const Duration(minutes: 10)),
      endInitialDate: DateTime.now().add(const Duration(minutes: 20)),
      startFirstDate: DateTime.now(),
      endFirstDate: DateTime.now(),
      startLastDate: DateTime.now().add(const Duration(days: 30)),
      endLastDate: DateTime.now().add(const Duration(days: 30)),
      minutesInterval: 5,
      borderRadius: const BorderRadius.all(Radius.circular(
        CurvatureSize.large,
      )),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, animA, animB, child) {
        return FadeTransition(
          opacity: animA.drive(
            Tween(
              begin: 0.0,
              end: 1.0,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(
        milliseconds: AnimationDuration.medium,
      ),
      barrierDismissible: true,
    );
  }
}
