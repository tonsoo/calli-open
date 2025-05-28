import 'package:calliopen/components/buttons/default_button.dart';
import 'package:calliopen/config/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GitHubProject extends StatelessWidget {
  const GitHubProject({super.key, this.buttonStyle});

  final ButtonStyle? buttonStyle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IntrinsicWidth(
        child: DefaultButton(
          onPressed: () async => {},
          buttonStyle: (buttonStyle ?? TextButton.styleFrom()).merge(
            TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                side: BorderSide.none,
              ),
            ),
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
