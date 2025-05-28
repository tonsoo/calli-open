import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get welcome_slogan => 'Tocador de musica gratis e open-source';

  @override
  String get login_errors_phone_too_short => 'Phone number is too short';

  @override
  String get login_errors_phone_too_long => 'Phone number is too long';

  @override
  String get login_errors_phone_invalid => 'Phone number is invalid';

  @override
  String get login_errors_phone_with_invalid_characters => 'Phone number contains invalid characters';

  @override
  String get login_errors_phone_empty => 'Phone number can not be empty';

  @override
  String get login_hints_phone => 'Type your phone';
}
