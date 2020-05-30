import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final sanguTheme = ThemeData(
  scaffoldBackgroundColor: Colors.black,
  brightness: Brightness.dark,
  primaryColor: Colors.white,
  backgroundColor: Colors.black,
  hoverColor: Colors.grey.withOpacity(0.4),
  focusColor: Colors.blueGrey.withOpacity(0.3),
  highlightColor: Colors.blueGrey.withOpacity(0.4),
  hintColor: Colors.grey.withOpacity(0.3),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    foregroundColor: Colors.black,
    backgroundColor: Colors.white70,
  ),
  iconTheme: IconThemeData(color: Colors.white, opacity: 1),
  textTheme: TextTheme(
    headline5: GoogleFonts.lato(
        fontSize: 24.0,
        color: Colors.white.withOpacity(0.5),
        letterSpacing: 15.0,
        fontWeight: FontWeight.w900),
    headline6: GoogleFonts.lato(fontSize: 18.0, color: Colors.black),
    headline4: GoogleFonts.lato(
        fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.w600),
    headline3: GoogleFonts.lato(fontSize: 15.0, color: Colors.white),
    headline2: GoogleFonts.lato(fontSize: 14.0, color: Colors.grey),
    subtitle2: GoogleFonts.lato(
        fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w400),
  ),
);
