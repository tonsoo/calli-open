import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

enum AppThemes { dark, light, device }

class PreferencesNotifier extends ChangeNotifier {
  PreferencesNotifier();

  AppThemes _appTheme = AppThemes.device;

  AppThemes get appTheme => _appTheme;
  set appTheme(AppThemes theme) {
    bool notify = theme != appTheme;
    _appTheme = theme;
    if (notify) notifyListeners();
  }

  void updateTheme() => notifyListeners();

  T themed<T>(BuildContext context, {required T light, required T dark}) {
    return switch (_appTheme) {
      AppThemes.dark => dark,
      AppThemes.light => light,
      AppThemes.device =>
        SchedulerBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark
            ? dark
            : light,
    };
  }
}

extension ContextExtension on BuildContext {
  T themed<T>({required T light, required T dark}) {
    return read<PreferencesNotifier>().themed(this, light: light, dark: dark);
  }

  T fromTheme<T>(Themed<T> theme) =>
      themed(light: theme.light, dark: theme.dark);
}

class Themed<T> {
  const Themed({required this.light, required this.dark});

  final T dark;
  final T light;

  static Themed<T> one<T>(T value) => Themed(light: value, dark: value);
}
