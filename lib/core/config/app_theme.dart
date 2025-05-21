import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../styles/color.dart';

class AppTheme {
  static ThemeData them = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      fontFamily: GoogleFonts.cairo().fontFamily,
      // iconTheme: const IconThemeData(color: Colors.white),
      appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          iconTheme: const IconThemeData(color: Colors.white)));
}
