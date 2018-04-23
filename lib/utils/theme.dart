import 'package:flutter/material.dart';

class AppTheme {

  static const Color appBackground = const Color(0xFF212323);
  static const Color greyColor = const Color(0xFF6D6E6E);
  static const Color greyColor2 = const Color(0xFFB6B6B6);
  static const Color greyColor3 = const Color(0xFF5A5A5A);
  static const Color appGreen = const Color(0xFF1FAC5D);
  static const Color appRed = const Color(0xFFD95730);

  static const double miniSize = 14.0;
  static const double largeSize = 28.0;

  static const TextStyle currencySelected = const TextStyle(
    color: Colors.black,
    fontSize: AppTheme.largeSize,
    fontWeight: FontWeight.w300,
    letterSpacing: 2.0
  );

  static const TextStyle currencyAmount = const TextStyle(
    color: Colors.white,
    fontSize: AppTheme.largeSize,
    fontWeight: FontWeight.w300,
    letterSpacing: 2.0
  );

  static const TextStyle currencyConversion = const TextStyle(
    color: AppTheme.greyColor,
    fontSize: AppTheme.miniSize,
    fontWeight: FontWeight.w300
  );

  static const TextStyle currencyConversionSelected = const TextStyle(
    color: AppTheme.greyColor3,
    fontSize: AppTheme.miniSize,
    fontWeight: FontWeight.w300
  );

  static const TextStyle currencyCodePositive = const TextStyle(
    color: AppTheme.appGreen,
    fontSize: AppTheme.largeSize,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.5
  );

  static const TextStyle currencyCodeNegative = const TextStyle(
    color: AppTheme.appRed,
    fontSize: AppTheme.largeSize,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.5
  );

  static const TextStyle currencyCodeNeutral = const TextStyle(
    color: Colors.blue,
    fontSize: AppTheme.largeSize,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.5
  );

  static const TextStyle currencyChangePositive = const TextStyle(
    color: AppTheme.appGreen,
    fontSize: AppTheme.miniSize,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.5
  );

  static const TextStyle currencyChangeNegative = const TextStyle(
    color: AppTheme.appRed,
    fontSize: AppTheme.miniSize,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.5
  );

  static const TextStyle currencyChangeNeutral = const TextStyle(
    color: Colors.blue,
    fontSize: AppTheme.miniSize,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.5
  );

}