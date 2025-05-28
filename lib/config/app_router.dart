import 'package:calliopen/routes/songs/songs_dashboard_screen.dart';
import 'package:calliopen/routes/start/login_screen.dart';
import 'package:calliopen/routes/start/welcome_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

final routerKey = GlobalKey<NavigatorState>();

GoRouter router() => GoRouter(
      navigatorKey: routerKey,
      initialLocation: SongsDashboardScreen.path,
      routes: [
        GoRoute(
            path: WelcomeScreen.path,
            builder: (context, state) => WelcomeScreen()),
        GoRoute(
            path: LoginScreen.path, builder: (context, state) => LoginScreen()),
        GoRoute(
            path: SongsDashboardScreen.path,
            builder: (context, state) => SongsDashboardScreen()),
      ],
    );
