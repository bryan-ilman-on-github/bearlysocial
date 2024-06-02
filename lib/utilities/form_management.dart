import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';

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
}
