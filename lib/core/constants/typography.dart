import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme buildTextTheme(TextTheme base) {
  final body = GoogleFonts.dmSansTextTheme(base);
  return body.copyWith(
    headlineLarge: GoogleFonts.spaceGrotesk(
      textStyle: body.headlineLarge,
      fontWeight: FontWeight.w700,
    ),
    headlineMedium: GoogleFonts.spaceGrotesk(
      textStyle: body.headlineMedium,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: GoogleFonts.spaceGrotesk(
      textStyle: body.headlineSmall,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: GoogleFonts.spaceGrotesk(
      textStyle: body.titleLarge,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: GoogleFonts.spaceGrotesk(
      textStyle: body.titleMedium,
      fontWeight: FontWeight.w600,
    ),
  );
}

TextStyle monoTextStyle(TextStyle? base) {
  return GoogleFonts.jetBrainsMono(textStyle: base);
}
