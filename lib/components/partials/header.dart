import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.featureItem,
    this.alignment = Alignment.center,
    this.leftWidget,
    this.rightWidget,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 17,
      vertical: 16,
    ),
  });

  final Widget? leftWidget;
  final Widget featureItem;
  final Widget? rightWidget;
  final EdgeInsets padding;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leftWidget != null) Flexible(child: leftWidget!),
              if (rightWidget != null) Flexible(child: rightWidget!),
            ],
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(
              right: 0,
            ),
            child: featureItem,
          ),
        ),
      ],
    );
  }
}
