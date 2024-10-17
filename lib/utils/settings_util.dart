import 'dart:ui';

import 'package:bearlysocial/constants/lang_code.dart';
import 'package:bearlysocial/constants/translations/en_translations.dart';
import 'package:easy_localization/easy_localization.dart';

class TranslationLoader extends AssetLoader {
  final Map _translations = {
    LanguageCode.en.name: enTranslations,
  };

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async =>
      Future(() => _translations[locale.toLanguageTag()]);
}
