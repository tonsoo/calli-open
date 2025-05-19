import 'package:calliopen/routes/start/welcome.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final routerKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: Welcome.path,
        navigatorKey: routerKey,
        redirectLimit: 5,
        routes: [Welcome.route],
      ),
    );
  }
}
