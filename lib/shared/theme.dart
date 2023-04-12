import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  textTheme: const TextTheme(
    //
    titleLarge: TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w600,
      letterSpacing: 3,
      color: Colors.white,
    ),
    //
    titleMedium: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: 3,
      color: Colors.white,
    ),
    //
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 3,
      color: Colors.white,
    ),
    //
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 20,
    ),
    //
  ),
);

//

final lightTheme = ThemeData(
  textTheme: TextTheme(
    //
    titleLarge: TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w600,
      letterSpacing: 3,
      color: Colors.black87.withOpacity(.75),
    ),
    //
    titleMedium: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: 3,
      color: Colors.black87.withOpacity(.75),
    ),
    //
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 3,
      color: Colors.black87.withOpacity(.75),
    ),
    //
    bodyMedium: const TextStyle(
      color: Colors.white,
      fontSize: 20,
    ),
    //
  ),
);
