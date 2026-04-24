// lib/theme.dart
import 'package:flutter/material.dart';

const kGreen = Color(0xFF16A34A);
const kGreenDark = Color(0xFF15803D);
const kGreenLight = Color(0xFFDCFCE7);
const kGreenBg = Color(0xFFF0FDF4);
const kRed = Color(0xFFDC2626);
const kRedLight = Color(0xFFFEE2E2);
const kRedBg = Color(0xFFFEF2F2);
const kYellow = Color(0xFFEAB308);
const kYellowLight = Color(0xFFFEF9C3);
const kBlue = Color(0xFF2563EB);
const kBlueLight = Color(0xFFDBEAFE);
const kGray50 = Color(0xFFF9FAFB);
const kGray100 = Color(0xFFF3F4F6);
const kGray200 = Color(0xFFE5E7EB);
const kGray300 = Color(0xFFD1D5DB);
const kGray400 = Color(0xFF9CA3AF);
const kGray500 = Color(0xFF6B7280);
const kGray700 = Color(0xFF374151);
const kGray900 = Color(0xFF111827);
const kWhite = Colors.white;

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: kGreen),
    scaffoldBackgroundColor: kGray50,
    appBarTheme: const AppBarTheme(
      backgroundColor: kWhite,
      foregroundColor: kGray900,
      elevation: 0,
      shadowColor: kGray200,
      surfaceTintColor: kWhite,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kWhite,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: kGray300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: kGray300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: kGreen, width: 2)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
      hintStyle: const TextStyle(color: kGray400, fontSize: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kGreen,
        foregroundColor: kWhite,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        elevation: 2,
      ),
    ),
  );
}
