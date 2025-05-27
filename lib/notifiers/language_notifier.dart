import 'package:calliopen/config/langs/dart/app_localizations.dart';
import 'package:calliopen/config/langs/dart/app_localizations_en.dart';
import 'package:calliopen/config/langs/dart/app_localizations_pt.dart';
import 'package:calliopen/main.dart';
import 'package:flutter/material.dart';

class LanguageNotifier extends ChangeNotifier with WidgetsBindingObserver {
  LanguageNotifier() {
    WidgetsBinding.instance.addObserver(this);
    _updateLang();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    setLang(Locales.fromCode(locales?.firstOrNull?.languageCode ?? ''));
  }

  static final defaultLocale = AppLocalizationsEn();

  Locales? _locale;

  AppLocalizations? _lang;
  AppLocalizations get lang => _lang ?? defaultLocale;

  void _updateLang({BuildContext? context}) =>
      _lang = getLang(context: context);

  AppLocalizations getLang({BuildContext? context}) {
    if (_locale != null) {
      return switch (_locale!) {
        Locales.pt => AppLocalizationsPt(),
        Locales.en => AppLocalizationsEn(),
      };
    }

    if (routerKey.currentContext == null && context == null) {
      return defaultLocale;
    }

    AppLocalizations? lang;

    if (context != null) {
      lang ??= AppLocalizations.of(context);
    }

    if (routerKey.currentContext != null) {
      lang ??= AppLocalizations.of(routerKey.currentContext!);
    }

    return lang ?? defaultLocale;
  }

  void setLang(Locales? locale, {BuildContext? context}) {
    _locale = locale;
    _updateLang();
    notifyListeners();
  }
}

enum Locales {
  pt,
  en;

  static String code(Locales locale) => switch (locale) {
        Locales.pt => 'pt',
        Locales.en => 'en',
      };

  static Locales fromCode(String code) => switch (code) {
        'en' => Locales.en,
        _ => Locales.pt,
      };
}
