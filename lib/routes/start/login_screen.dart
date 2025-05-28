import 'package:calliopen/components/inputs/default_phone_input.dart';
import 'package:calliopen/components/partials/header.dart';
import 'package:calliopen/config/app_colors.dart';
import 'package:calliopen/config/app_icons.dart';
import 'package:calliopen/notifiers/preferences_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const path = '/auth/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.themed(
        light: AppColors.white,
        dark: AppColors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Header(
              padding: EdgeInsets.symmetric(vertical: 42, horizontal: 32),
              leftWidget: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.pop(),
                child: SvgPicture.asset(
                  AppIcons.icons.arrows.back,
                  width: 27,
                  height: 27,
                  color: context.themed(
                    light: AppColors.black,
                    dark: AppColors.white,
                  ),
                ),
              ),
              featureItem: Text(
                'Contact'.toUpperCase(),
                style: TextStyle(
                  color: context.themed(
                    light: AppColors.black,
                    dark: AppColors.white,
                  ),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 9),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: DefaultPhoneInput(
                onSubmit: () async => {},
                fillState: (_) => false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
