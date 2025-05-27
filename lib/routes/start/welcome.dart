import 'dart:math';

import 'package:calliopen/components/buttons/default_button.dart';
import 'package:calliopen/config/app_colors.dart';
import 'package:calliopen/config/app_icons.dart';
import 'package:calliopen/notifiers/language_notifier.dart';
import 'package:calliopen/notifiers/preferences_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  static const path = '/welcome';

  @override
  Widget build(BuildContext context) {
    context.read<PreferencesNotifier>();
    context.read<LanguageNotifier>();

    return Scaffold(
      backgroundColor: context.themed(
        light: AppColors.white,
        dark: AppColors.black,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 124),
            SvgPicture.asset(AppIcons.icons.logo, width: 149, height: 118),
            SizedBox(height: 18),
            Text(
              'Calli Open',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.themed(
                  light: AppColors.black,
                  dark: AppColors.white,
                ),
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 90),
            Text(
              'Free open-source music player',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.themed(
                  light: AppColors.black,
                  dark: AppColors.white,
                ),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              softWrap: true,
            ),
            SizedBox(height: 102),
            _LoginButton(),
            Expanded(child: Container()),
            _GitHubProject(),
            SizedBox(height: 35)
          ],
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: min(224, MediaQuery.of(context).size.width * .9),
        ),
        child: DefaultButton(
          onPressed: () async => {},
          buttonStyle: TextButton.styleFrom(
            backgroundColor: context.themed(
              light: AppColors.main,
              dark: AppColors.main,
            ),
            foregroundColor: context.themed(
              light: AppColors.black,
              dark: AppColors.black,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.5)),
              side: BorderSide.none,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
          ),
          child: Text(
            'Login'.toUpperCase(),
            style: TextStyle(
              color: context.themed(
                light: AppColors.white,
                dark: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GitHubProject extends StatelessWidget {
  const _GitHubProject({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IntrinsicWidth(
        child: DefaultButton(
          onPressed: () async => {},
          buttonStyle: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 5,
            children: [
              SvgPicture.asset(
                AppIcons.icons.github,
                width: 9,
                height: 9,
                fit: BoxFit.contain,
              ),
              Text('Github Project')
            ],
          ),
        ),
      ),
    );
  }
}
