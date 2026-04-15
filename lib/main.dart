import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const NeonNocturneApp());
}

class NeonNocturneApp extends StatelessWidget {
  const NeonNocturneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neon Nocturne',
      theme: AppTheme.darkTheme.copyWith(
        textTheme: GoogleFonts.interTextTheme(AppTheme.darkTheme.textTheme).copyWith(
          displayLarge: GoogleFonts.manrope(textStyle: AppTheme.darkTheme.textTheme.displayLarge),
          displayMedium: GoogleFonts.manrope(textStyle: AppTheme.darkTheme.textTheme.displayMedium),
          displaySmall: GoogleFonts.manrope(textStyle: AppTheme.darkTheme.textTheme.displaySmall),
          headlineLarge: GoogleFonts.manrope(textStyle: AppTheme.darkTheme.textTheme.headlineLarge),
          headlineMedium: GoogleFonts.manrope(textStyle: AppTheme.darkTheme.textTheme.headlineMedium),
          headlineSmall: GoogleFonts.manrope(textStyle: AppTheme.darkTheme.textTheme.headlineSmall),
          titleLarge: GoogleFonts.manrope(textStyle: AppTheme.darkTheme.textTheme.titleLarge),
          titleMedium: GoogleFonts.manrope(textStyle: AppTheme.darkTheme.textTheme.titleMedium),
          titleSmall: GoogleFonts.manrope(textStyle: AppTheme.darkTheme.textTheme.titleSmall),
        ),
      ),
      home: const MainScreen(),
    );
  }
}
