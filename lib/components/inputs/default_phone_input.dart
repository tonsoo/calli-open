import 'dart:math';

import 'package:calliopen/config/app_colors.dart';
import 'package:calliopen/notifiers/language_notifier.dart';
import 'package:calliopen/notifiers/preferences_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/country_picker_dialog.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:flutter_intl_phone_field/phone_number.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:provider/provider.dart';

class DefaultPhoneInput extends StatefulWidget {
  DefaultPhoneInput({
    super.key,
    required this.onSubmit,
    required this.fillState,
    this.controller,
  });

  final TextEditingController? controller;
  final hiddenController = TextEditingController();
  final void Function() onSubmit;
  final void Function(bool) fillState;

  @override
  State<DefaultPhoneInput> createState() => DefaultPhoneInputState();
}

class DefaultPhoneInputState extends State<DefaultPhoneInput> {
  PhoneCountryData? country;
  String? _error;
  static const String initialCountry = 'BR';

  @override
  void initState() {
    super.initState();

    setState(() {
      country = _getCountry(initialCountry);
    });
  }

  PhoneCountryData? _getCountry(String code) {
    final data = PhoneCodes.findCountryDatasByCountryCodes(
      countryIsoCodes: [
        code,
      ],
    );

    return data.firstOrNull;
  }

  String? _setError(String? err, {bool setError = true}) {
    if (setError) {
      setState(() {
        _error = err;
      });
    }
    return err;
  }

  String? _handlePhoneExceptions(String? Function() action,
      {bool setError = true}) {
    final lang = context.read<LanguageNotifier>().lang;

    String? error;
    try {
      error = action();
    } on NumberTooShortException {
      error = lang.login_errors_phone_too_short;
    } on NumberTooLongException {
      error = lang.login_errors_phone_too_long;
    } on InvalidCharactersException {
      error = lang.login_errors_phone_with_invalid_characters;
    } on Exception {
      error = lang.login_errors_phone_invalid;
    }

    return _setError(error, setError: setError);
  }

  String? _validatePhoneNumber(String? phoneNumber, {bool setError = true}) {
    final lang = context.read<LanguageNotifier>().lang;

    if (phoneNumber == null || phoneNumber.isEmpty) {
      return _setError(lang.login_errors_phone_empty, setError: setError);
    }

    return _handlePhoneExceptions(
      () {
        final phone = PhoneNumber(
            countryISOCode: '${country?.countryCode}',
            countryCode: '+${country?.internalPhoneCode}',
            number: phoneNumber);
        if (phone.completeNumber.isEmpty) {
          return _setError(lang.login_errors_phone_empty, setError: setError);
        }

        PhoneNumber(
          countryCode: phone.countryCode,
          number: phone.number.replaceAll(RegExp(r'[^0-9]'), ''),
          countryISOCode: phone.countryISOCode,
        ).isValidNumber();
        return _setError(null, setError: setError);
      },
      setError: setError,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final lang = context.read<LanguageNotifier>().lang;
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: Opacity(
            opacity: 0,
            child: TextFormField(
              controller: widget.hiddenController,
              validator: _validatePhoneNumber,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 5,
          children: [
            IntlPhoneField(
              onSubmitted: (s) => widget.onSubmit(),
              textInputAction: TextInputAction.send,
              controller: widget.controller,
              flagsButtonPadding: EdgeInsets.only(
                left: 16,
              ),
              onChanged: (phone) {
                widget.hiddenController.text = phone.number;

                final error = _validatePhoneNumber(
                  phone.number,
                  setError: false,
                );
                widget.fillState(error == null);
              },
              pickerDialogStyle: PickerDialogStyle(
                backgroundColor: context.themed(
                  light: AppColors.white,
                  dark: AppColors.black,
                ),
                width: min(800, screenWidth * .9),
                countryNameStyle: TextStyle(
                  color: context.themed(
                    light: AppColors.black,
                    dark: AppColors.white,
                  ),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                countryCodeStyle: TextStyle(
                  color: context.themed(
                    light: AppColors.gray,
                    dark: AppColors.gray,
                  ),
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                listTilePadding: EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 10,
                ),
                listTileDivider: Container(
                  decoration: BoxDecoration(
                    color: context.themed(
                      light: AppColors.gray,
                      dark: AppColors.gray,
                    ),
                  ),
                  height: 1,
                ),
                searchFieldInputDecoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  fillColor: AppColors.whiteMid,
                  filled: true,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: context.themed(
                        light: AppColors.gray,
                        dark: AppColors.gray,
                      ),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.orangeMid,
                    ),
                  ),
                  focusColor: AppColors.orangeMid,
                  hintText: lang.login_hints_phone,
                  hintStyle: TextStyle(
                    color: context.themed(
                      light: AppColors.gray,
                      dark: AppColors.gray,
                    ),
                    fontSize: 16,
                  ),
                ),
                searchFieldCursorColor: AppColors.orangeMid,
                searchFieldPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide.none,
                ),
                fillColor: AppColors.gray,
                filled: true,
                contentPadding: EdgeInsets.all(0),
                hintText: country?.phoneMaskWithoutCountryCode,
                hintStyle: TextStyle(
                  color: context.themed(
                    light: AppColors.gray,
                    dark: AppColors.gray,
                  ),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                errorStyle: TextStyle(
                  color: Color(0xffdc3353),
                ),
              ),
              initialCountryCode: initialCountry,
              dropdownIconPosition: IconPosition.trailing,
              showCountryFlag: false,
              onCountryChanged: (country) => setState(() {
                final data = PhoneCodes.findCountryDatasByCountryCodes(
                    countryIsoCodes: [country.code]);
                if (data.isEmpty) {
                  this.country = null;
                  return;
                }

                this.country = _getCountry(country.code);
              }),
              inputFormatters: [
                PhoneInputFormatter(
                  allowEndlessPhone: false,
                  defaultCountryCode: country?.countryCode,
                )
              ],
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
              disableLengthCheck: true,
            ),
            if (_error?.isEmpty == false)
              Text(
                _error!,
                style: TextStyle(
                  color: Color(0xffdc3353),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
