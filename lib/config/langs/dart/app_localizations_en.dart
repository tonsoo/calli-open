import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome_slogan => 'Free open-source music player';

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
