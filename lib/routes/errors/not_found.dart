import 'package:calliopen/config/app_colors.dart';
import 'package:calliopen/notifiers/preferences_notifier.dart';
import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  static const path = '/404';

  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    print('context_read here #4');
    return Scaffold(
      backgroundColor: context.themed(
        light: AppColors.white,
        dark: AppColors.black,
      ),
      body: SafeArea(child: Container()),
    );
  }
}
