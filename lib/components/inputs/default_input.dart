import 'package:calliopen/config/app_colors.dart';
import 'package:calliopen/notifiers/preferences_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultInput extends StatelessWidget {
  const DefaultInput({
    super.key,
    this.decoration,
    this.controller,
    this.readOnly = false,
    this.onTap,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autofillHints,
    this.initialValue,
    this.style,
    this.cursorColor,
    this.focusNode,
    this.minLines,
    this.maxLines,
  });

  final InputDecoration? decoration;
  final TextEditingController? controller;
  final bool readOnly;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final void Function(String value)? onFieldSubmitted;
  final Iterable<String>? autofillHints;
  final String? initialValue;
  final TextStyle? style;
  final Color? cursorColor;
  final FocusNode? focusNode;
  final int? minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
      minLines: minLines,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      autofillHints: autofillHints,
      initialValue: initialValue,
      focusNode: focusNode,
      decoration: (decoration ?? InputDecoration()).applyDefaults(
        InputDecorationTheme(
          filled: true,
          fillColor: context.themed(
            light: AppColors.whiteMid,
            dark: AppColors.white,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(
            color: context.themed(
              light: AppColors.gray,
              dark: AppColors.whiteMid,
            ),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 16,
          ),
        ),
      ),
      cursorColor: cursorColor,
      style: TextStyle(
        color: AppColors.black,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
