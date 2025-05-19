import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  static const path = '/welcome';
  static final route = GoRoute(
    path: path,
    builder: (context, state) => Welcome(),
  );

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
