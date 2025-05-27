import 'package:calliopen/config/app_colors.dart';
import 'package:calliopen/notifiers/preferences_notifier.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatefulWidget {
  const DefaultButton({
    super.key,
    required this.onPressed,
    this.buttonStyle,
    this.showLoading = true,
    this.loadingStyle,
    this.loadingOpacity = 0,
    required this.child,
  });

  final Widget child;
  final Future<void> Function() onPressed;
  final ButtonStyle? buttonStyle;
  final bool showLoading;
  final LoadingStyle? loadingStyle;
  final double loadingOpacity;

  @override
  State<DefaultButton> createState() => DefaultButtonState();
}

class DefaultButtonState extends State<DefaultButton> {
  late LoadingStyle loadingStyle;
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    loadingStyle = LoadingStyle(
      color: context.themed(light: AppColors.white, dark: AppColors.black),
      size: 15,
      strokeWidth: 2.40,
    ).merge(widget.loadingStyle);
  }

  void _load(bool state) => mounted
      ? setState(() {
          _loading = state;
        })
      : null;

  Future<void> click() async {
    if (_loading) return;

    try {
      _load(true);
      await widget.onPressed();
      _load(false);
    } on Exception {
      _load(false);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: click,
              style: (widget.buttonStyle ?? TextButton.styleFrom()).merge(
                TextButton.styleFrom(
                  backgroundColor: context.themed(
                    light: AppColors.white,
                    dark: AppColors.black,
                  ),
                  foregroundColor: context.themed(
                    light: AppColors.black,
                    dark: AppColors.white,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  minimumSize: Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              child: Opacity(
                opacity:
                    _loading && widget.showLoading ? widget.loadingOpacity : 1,
                child: widget.child,
              ),
            ),
          ],
        ),
        if (widget.showLoading)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Opacity(
              opacity: _loading && widget.showLoading ? 1 : 0,
              child: Center(
                child: SizedBox(
                  width: loadingStyle.size,
                  height: loadingStyle.size,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CircularProgressIndicator(
                      backgroundColor: loadingStyle.backgroundColor,
                      color: loadingStyle.color,
                      semanticsLabel: loadingStyle.semanticsLabel,
                      semanticsValue: loadingStyle.semanticsValue,
                      strokeAlign: loadingStyle.strokeAlign,
                      strokeCap: loadingStyle.strokeCap,
                      strokeWidth: loadingStyle.strokeWidth,
                      value: loadingStyle.value,
                      valueColor: loadingStyle.valueColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class LoadingStyle {
  const LoadingStyle({
    this.value,
    this.backgroundColor,
    this.color,
    this.valueColor,
    this.strokeWidth = 4,
    this.strokeAlign = 0,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeCap,
    this.size,
  });

  final double? value;
  final Color? backgroundColor;
  final Color? color;
  final Animation<Color?>? valueColor;
  final double strokeWidth;
  final double strokeAlign;
  final String? semanticsLabel;
  final String? semanticsValue;
  final StrokeCap? strokeCap;
  final double? size;

  LoadingStyle merge(LoadingStyle? style) {
    return LoadingStyle(
      backgroundColor: style?.backgroundColor ?? backgroundColor,
      color: style?.color ?? color,
      semanticsLabel: style?.semanticsLabel ?? semanticsLabel,
      semanticsValue: style?.semanticsValue ?? semanticsValue,
      strokeAlign: style?.strokeAlign ?? strokeAlign,
      strokeCap: style?.strokeCap ?? strokeCap,
      strokeWidth: style?.strokeWidth ?? strokeWidth,
      value: style?.value ?? value,
      valueColor: style?.valueColor ?? valueColor,
      size: style?.size ?? size,
    );
  }
}
