import 'package:calliopen/routes/start/welcome.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

final routerKey = GlobalKey<NavigatorState>();

GoRouter router() => GoRouter(
      navigatorKey: routerKey,
      initialLocation: Welcome.path,
      routes: [
        GoRoute(path: Welcome.path, builder: (context, state) => Welcome())
      ],
    );
