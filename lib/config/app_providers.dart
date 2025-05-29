import 'package:calliopen/helpers/audio_manager.dart';
import 'package:calliopen/notifiers/language_notifier.dart';
import 'package:calliopen/notifiers/preferences_notifier.dart';
import 'package:calliopen/notifiers/track_notifier.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final providers = <SingleChildWidget>[
  Provider(create: (context) => AudioManager()),
  ChangeNotifierProvider(create: (context) => PreferencesNotifier()),
  ChangeNotifierProvider(create: (context) => LanguageNotifier()),
  ChangeNotifierProvider(create: (context) => TrackNotifier(context.read())),
];
