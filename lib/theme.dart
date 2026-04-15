import 'package:flutter/material.dart';

class AppTheme {
  static const Color surfaceContainerHighest = Color(0xff25252a);
  static const Color inverseSurface = Color(0xfffcf8fd);
  static const Color secondaryFixedDim = Color(0xff00d7f0);
  static const Color onBackground = Color(0xfff0edf1);
  static const Color tertiaryFixedDim = Color(0xffff769b);
  static const Color background = Color(0xff0e0e11);
  static const Color onSecondaryFixedVariant = Color(0xff005964);
  static const Color primaryFixedDim = Color(0xff9c7eff);
  static const Color outline = Color(0xff767579);
  static const Color surfaceTint = Color(0xffb6a0ff);
  static const Color surfaceVariant = Color(0xff25252a);
  static const Color errorDim = Color(0xffd73357);
  static const Color onSurfaceVariant = Color(0xffacaaae);
  static const Color onError = Color(0xff490013);
  static const Color surfaceContainerLowest = Color(0xff000000);
  static const Color inversePrimary = Color(0xff6834eb);
  static const Color secondaryDim = Color(0xff00d4ec);
  static const Color onSecondary = Color(0xff004d57);
  static const Color surfaceBright = Color(0xff2c2c30);
  static const Color surfaceDim = Color(0xff0e0e11);
  static const Color surfaceContainerLow = Color(0xff131316);
  static const Color errorContainer = Color(0xffa70138);
  static const Color onTertiaryFixedVariant = Color(0xff770033);
  static const Color onSecondaryContainer = Color(0xffe8fbff);
  static const Color surface = Color(0xff0e0e11);
  static const Color tertiaryContainer = Color(0xfffd3e80);
  static const Color error = Color(0xffff6e84);
  static const Color onPrimaryFixed = Color(0xff000000);
  static const Color secondaryContainer = Color(0xff006875);
  static const Color outlineVariant = Color(0xff48474b);
  static const Color surfaceContainer = Color(0xff19191d);
  static const Color inverseOnSurface = Color(0xff555458);
  static const Color tertiaryDim = Color(0xffff6c95);
  static const Color onSecondaryFixed = Color(0xff003a42);
  static const Color onTertiaryContainer = Color(0xff100003);
  static const Color tertiaryFixed = Color(0xffff8fa9);
  static const Color onPrimary = Color(0xff340090);
  static const Color onErrorContainer = Color(0xffffb2b9);
  static const Color secondary = Color(0xff00e3fd);
  static const Color onTertiary = Color(0xff48001c);
  static const Color surfaceContainerHigh = Color(0xff1f1f23);
  static const Color primaryContainer = Color(0xffa98fff);
  static const Color primaryFixed = Color(0xffa98fff);
  static const Color primary = Color(0xffb6a0ff);
  static const Color onSurface = Color(0xfff0edf1);
  static const Color tertiary = Color(0xffff6c95);
  static const Color primaryDim = Color(0xff7e51ff);
  static const Color onPrimaryFixedVariant = Color(0xff32008a);
  static const Color onPrimaryContainer = Color(0xff280072);
  static const Color secondaryFixed = Color(0xff26e6ff);

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      surface: surface,
      onSurface: onSurface,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      outline: outline,
      outlineVariant: outlineVariant,
    ),
    scaffoldBackgroundColor: background,
    useMaterial3: true,
  );
}
