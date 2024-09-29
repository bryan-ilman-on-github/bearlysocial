import 'package:bearlysocial/components/form_elements/tag.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/constants/translation_key.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

/// This class provides utility functions for form operations.
class FormUtils {
  /// This function validates an email address using a regular expression.
  ///
  /// The `emailAddress` parameter is the email address to be validated.
  static bool validateEmailAddress({
    required String emailAddress,
  }) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );

    return emailRegExp.hasMatch(emailAddress);
  }

  /// This function checks if two lists contain the same elements.
  ///
  /// The `listA` and `listB` parameters are the lists to be compared.
  static bool doListsContainSameElements({
    required List<dynamic> listA,
    required List<dynamic> listB,
  }) {
    return Set.from(listA).difference(Set.from(listB)).isEmpty &&
        Set.from(listB).difference(Set.from(listA)).isEmpty;
  }

  /// This function calculates a color based on a rating value.
  ///
  /// The `rating` parameter is a value between 0.0 and 5.0 that determines the color.
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

  /// This function displays a date-time range picker dialog.
  ///
  /// The `context` parameter is the BuildContext used to display the dialog.
  /// The function returns a Future that completes with a list containing the start and end DateTime,
  /// or `null` if the dialog is dismissed.
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

  /// This function builds a list of DropdownMenuEntry from a map of entries.
  ///
  /// The `entries` parameter is a map where keys are menu item labels and values are the corresponding values.
  static List<DropdownMenuEntry> buildDropdownMenu({
    required Map<String, dynamic> entries,
  }) {
    final List<DropdownMenuEntry> menu = <DropdownMenuEntry>[];

    entries.forEach((key, value) {
      menu.add(
        DropdownMenuEntry(
          value: value,
          label: key,
        ),
      );
    });

    return menu;
  }

  /// This function builds a list of Tag widgets from a list of labels.
  ///
  /// The `collection` parameter is a list of labels for the tags.
  /// The `callbackFunction` parameter is a function to be called when a tag is interacted with.
  static List<Tag> buildTags({
    required List<String> collection,
    required Function callbackFunction,
  }) {
    List<Tag> tags = [];

    for (var label in collection) {
      tags.add(
        Tag(
          label: label,
          callbackFunction: callbackFunction,
        ),
      );
    }

    return tags;
  }

  /// This getter returns a map of all interests with their corresponding TranslationKey.
  static Map<String, TranslationKey> get allInterests {
    final List<TranslationKey> interestKeys = TranslationKey.values
        .where((key) => key.toString().contains('INTEREST_LBL'))
        .toList();

    return {for (var key in interestKeys) key.name.tr(): key};
  }
}
