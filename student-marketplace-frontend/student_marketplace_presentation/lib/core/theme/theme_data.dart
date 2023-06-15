import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//Color accentColor = const Color.fromARGB(255, 94, 64, 175);
Color accentColor = const Color.fromARGB(255, 255, 127, 80);

ThemeData lightTheme() => ThemeData(
      primaryColor: Colors.white,
      highlightColor: const Color.fromARGB(255, 240, 240, 240),
      dividerColor: const Color.fromARGB(255, 200, 200, 200),
      splashColor: accentColor,
      textTheme: GoogleFonts.robotoTextTheme(
        const TextTheme(
            labelLarge: TextStyle(fontSize: 20, color: Colors.black),
            labelMedium: TextStyle(fontSize: 16, color: Colors.black),
            labelSmall: TextStyle(fontSize: 12, color: Colors.black),
            displayMedium: TextStyle(
                fontSize: 16, color: Color.fromARGB(255, 180, 180, 180)),
            displaySmall: TextStyle(
                fontSize: 12, color: Color.fromARGB(255, 180, 180, 180))),
      ),
    );

ThemeData darkTheme() => ThemeData(
      primaryColor: Colors.black,
      splashColor: accentColor,
      highlightColor: const Color.fromARGB(255, 33, 33, 33),
      dividerColor: const Color.fromARGB(255, 130, 130, 130),
      iconTheme: IconThemeData(color: accentColor),
      appBarTheme: const AppBarTheme(
        color: Colors.red,
      ),
      textTheme: GoogleFonts.robotoTextTheme(
        const TextTheme(
            labelLarge: TextStyle(fontSize: 20, color: Colors.white),
            labelMedium: TextStyle(fontSize: 16, color: Colors.white),
            labelSmall: TextStyle(fontSize: 12, color: Colors.white),
            displayMedium: TextStyle(
                fontSize: 16, color: Color.fromARGB(255, 130, 130, 130)),
            displaySmall: TextStyle(
                fontSize: 12, color: Color.fromARGB(255, 130, 130, 130))),
      ),
    );
