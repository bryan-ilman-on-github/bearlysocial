import 'package:bearlysocial/constants/lang_code.dart';
import 'package:bearlysocial/constants/translations/fragments/en_frag_mapping.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TranslationLoader extends AssetLoader {
  final Map<String, Map<String, String>> _translations = _localizationMappings;

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async =>
      Future(() => _translations[locale.toLanguageTag()]);
}

final Map<String, Map<String, String>> _localizationMappings = {
  LanguageCode.en.name: {
    ...enFragMapping,
  },
  LanguageCode.fr.name: {},
  LanguageCode.de.name: {},
  LanguageCode.nl.name: {},
  LanguageCode.es.name: {},
  LanguageCode.it.name: {},
  LanguageCode.pt.name: {},
  LanguageCode.ru.name: {},
  LanguageCode.ja.name: {},
  LanguageCode.ko.name: {},
};
