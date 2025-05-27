import 'package:calliopen/notifiers/language_notifier.dart';
import 'package:calliopen/notifiers/preferences_notifier.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final providers = <SingleChildWidget>[
  ChangeNotifierProvider(
    create: (context) => PreferencesNotifier(),
  ),
  ChangeNotifierProvider(
    create: (context) => LanguageNotifier(),
  ),
];
