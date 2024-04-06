import 'dart:convert';

import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';

class FormManagement {
  static bool validateEmail({
    required String email,
  }) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );

    return emailRegExp.hasMatch(email);
  }

  /// Parses a JSON-formatted string into a list of strings.
  /// Returns an empty list if the input is empty or invalid.
  ///
  /// Example:
  /// ```
  /// String jsonString = '["itemA","itemB","itemC"]';
  /// List<String> result = stringToList(jsonString);
  /// print(result);  // Output: [itemA, itemB, itemC]
  /// ```
  static List<String> stringToList({required String jsonListString}) {
    if (jsonListString.isEmpty) {
      return [];
    } else {
      try {
        List<dynamic> parsedList = json.decode(jsonListString);
        // Check if the parsed data is a list of strings
        if (parsedList is List<String>) {
          return parsedList;
        } else {
          // If not a list of strings, return an empty list
          return [];
        }
      } catch (e) {
        // If there's an error in parsing, return an empty list
        return [];
      }
    }
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
