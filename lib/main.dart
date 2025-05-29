import 'package:calliopen/config/app_providers.dart';
import 'package:calliopen/config/app_router.dart';
import 'package:calliopen/config/langs/dart/app_localizations.dart';
import 'package:calliopen/notifiers/language_notifier.dart';
import 'package:calliopen/notifiers/preferences_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:provider/provider.dart';

final routerKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MetadataGod.initialize();
  await Hive.initFlutter();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.calliopen.audio',
    androidNotificationChannelName: 'CalliOpen',
    androidNotificationOngoing: true,
  );
  runApp(MultiProvider(providers: providers, child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoRouter _router;
  late PlatformDispatcher _dispatcher;

  @override
  void initState() {
    super.initState();
    _router = router();

    _dispatcher = SchedulerBinding.instance.platformDispatcher;

    _dispatcher.onPlatformBrightnessChanged = () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print('context_read here #1');
        final prefs = context.read<PreferencesNotifier>();
        if (prefs.appTheme != AppThemes.device) return;
        prefs.updateTheme();
      });
    };
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales:
          Locales.values.map((l) => Locale(Locales.code(l))).toList(),
    );
  }
}
