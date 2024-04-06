import 'package:bearlysocial/components/form_elements/tag.dart';
import 'package:bearlysocial/constants/translation_key.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DropdownOperation {
  static List<DropdownMenuEntry> buildMenu({
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

  static List<String> addLabel({
    required Map<String, dynamic> menu,
    required String labelToAdd,
    required List<String> labelCollection,
  }) =>
      menu.containsKey(labelToAdd) && labelCollection.length >= 4
          ? <String>[...labelCollection..removeAt(0), labelToAdd]
          : menu.containsKey(labelToAdd)
              ? <String>[...labelCollection, labelToAdd]
              : labelCollection;

  static List<String> removeLabel({
    required String labelToRemove,
    required List<String> labelCollection,
  }) =>
      List.from(labelCollection)..remove(labelToRemove);

  static Map<String, TranslationKey> get allInterests {
    final List<TranslationKey> interestKeys = [
      TranslationKey.artificialIntelligenceLabel,
      TranslationKey.astronomyLabel,
      TranslationKey.badmintonLabel,
      TranslationKey.baseballLabel,
      TranslationKey.basketballLabel,
      TranslationKey.birdwatchingLabel,
      TranslationKey.campingLabel,
      TranslationKey.chessLabel,
      TranslationKey.climateChangeLabel,
      TranslationKey.codingLabel,
      TranslationKey.collectingLabel,
      TranslationKey.comicBooksLabel,
      TranslationKey.cookingLabel,
      TranslationKey.cybersecurityLabel,
      TranslationKey.cyclingLabel,
      TranslationKey.dancingLabel,
      TranslationKey.diyProjectsLabel,
      TranslationKey.drawingLabel,
      TranslationKey.economyLabel,
      TranslationKey.fishingLabel,
      TranslationKey.footBallLabel,
      TranslationKey.gamingLabel,
      TranslationKey.gardeningLabel,
      TranslationKey.geneticEngineeringLabel,
      TranslationKey.golfLabel,
      TranslationKey.hikingLabel,
      TranslationKey.historyLabel,
      TranslationKey.iceHockeyLabel,
      TranslationKey.immigrationLabel,
      TranslationKey.lgbtRightsLabel,
      TranslationKey.martialArtsLabel,
      TranslationKey.mathematicsLabel,
      TranslationKey.meditationLabel,
      TranslationKey.mentalHealthLabel,
      TranslationKey.novelsLabel,
      TranslationKey.paintingLabel,
      TranslationKey.parkourLabel,
      TranslationKey.photographyLabel,
      TranslationKey.playingMusicalInstrumentsLabel,
      TranslationKey.politicsLabel,
      TranslationKey.quantumPhysicsLabel,
      TranslationKey.racialInequalityLabel,
      TranslationKey.rocketScienceLabel,
      TranslationKey.rugbyLabel,
      TranslationKey.runningLabel,
      TranslationKey.sewingLabel,
      TranslationKey.stockMarketLabel,
      TranslationKey.swimmingLabel,
      TranslationKey.tennisLabel,
      TranslationKey.travelingLabel,
      TranslationKey.volleyballLabel,
      TranslationKey.volunteeringLabel,
      TranslationKey.warfareLabel,
      TranslationKey.watchingMoviesLabel,
      TranslationKey.writingLabel,
      TranslationKey.yogaLabel,
    ];

    return {for (var key in interestKeys) key.name.tr(): key};
  }
}
