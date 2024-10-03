import 'package:bearlysocial/components/form_elements/tag.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/constants/translation_key.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

/// This class provides utility functions for handling various form-related operations.
class FormUtility {
  /// Checks if at least one element is shared between two lists.
  ///
  /// The `listA` and `listB` parameters represent the two lists being compared.
  ///
  /// This function converts both lists to sets and checks if they have any overlapping elements.
  /// Returns `true` if there is at least one common element; otherwise, returns `false`.
  static bool doListsContainSameElements({
    required List<dynamic> listA,
    required List<dynamic> listB,
  }) {
    return Set.from(listA).difference(Set.from(listB)).isEmpty &&
        Set.from(listB).difference(Set.from(listA)).isEmpty;
  }

  /// Calculates a color based on a rating value, creating a gradient effect from red to green.
  ///
  /// The `rating` parameter is a double between 0.0 and 5.0.
  ///
  /// The function interpolates between three colors: red (low rating), yellow (middle rating), and green (high rating).
  /// Returns a color representing the rating. Defaults to transparent if no color is determined.
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

  /// Opens a date-time range picker with specified configuration and returns the selected date range.
  ///
  /// The `context` parameter is required to display the picker in the proper location.
  ///
  /// Returns a `Future<List<DateTime>?>` representing the selected start and end dates, or null if the picker is dismissed.
  /// The picker is configured for 24-hour mode, with specific start and end ranges and customizable transition effects.
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
      transitionBuilder: (_, animA, animB, child) {
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

  /// Builds a dropdown menu from a map of entries.
  ///
  /// The `entries` parameter is a map where keys represent labels and values represent corresponding dropdown values.
  ///
  /// Returns a list of `DropdownMenuEntry` objects, each containing a label and value from the provided entries map.
  static List<DropdownMenuEntry> buildDropdownMenu({
    required Map<String, dynamic> entries,
  }) {
    final List<DropdownMenuEntry> menu = <DropdownMenuEntry>[];

    entries.forEach((key, value) {
      menu.add(DropdownMenuEntry(value: value, label: key));
    });

    return menu;
  }

  /// Builds a list of tags from a given collection of strings.
  ///
  /// The `collection` parameter represents the list of strings to convert into tags.
  ///
  /// The `callbackFunction` parameter is the function invoked when the tag is interacted with.
  ///
  /// Returns a list of `Tag` objects, each created with a label from the `collection` and linked to the provided `callbackFunction`.
  static List<Tag> buildTags({
    required List<String> collection,
    required Function callbackFunction,
  }) {
    List<Tag> tags = [];

    for (var label in collection) {
      tags.add(
        Tag(label: label, callbackFunction: callbackFunction),
      );
    }

    return tags;
  }

  /// Retrieves all translation keys related to user interests.
  ///
  /// This getter filters the `TranslationKey` enum values to return only those containing the 'INTEREST_LBL' label.
  ///
  /// Returns a map where each key represents the translated interest name and the value is the corresponding `TranslationKey`.
  static Map<String, TranslationKey> get allInterests {
    final List<TranslationKey> interestKeys = TranslationKey.values
        .where((key) => key.toString().contains('INTEREST_LBL'))
        .toList();

    return {for (var key in interestKeys) key.name.tr(): key};
  }
}
