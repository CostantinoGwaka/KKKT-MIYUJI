import 'package:flutter/material.dart';
import '../utils/my_colors.dart';

enum AppTheme { White, Dark }

/// Returns enum value name without enum class name.
String enumName(AppTheme anyEnum) {
  return anyEnum.toString().split('.')[1];
}

final appThemeData = {
  AppTheme.White: ThemeData(
    dialogTheme: const DialogTheme(
        titleTextStyle: TextStyle(
      color: Colors.black,
    )),
    brightness: Brightness.light,
    primaryColor: MyColors.primary,
    //primarySwatch: MyColors.primary,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: MyColors.primary,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    ),
    cardTheme: const CardTheme(
      color: Colors.white,
    ),
    iconTheme: const IconThemeData(
      color: Colors.black87,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontFamily: 'WorkSans',
      ),
      headlineMedium: TextStyle(
        color: Colors.black54,
        fontFamily: 'WorkSans',
      ),
      titleSmall: TextStyle(
        color: Colors.white70,
        fontFamily: 'WorkSans',
        fontSize: 18.0,
      ),
    ),
  ),
  AppTheme.Dark: ThemeData(
    //scaffoldBackgroundColor: MyColors.grey_90,
    //primaryColor: MyColors.grey_90,
    brightness: Brightness.dark,
    dialogTheme: const DialogTheme(
        titleTextStyle: TextStyle(
      color: Colors.white,
    )),
    bottomSheetTheme: const BottomSheetThemeData(
        //backgroundColor: MyColors.grey_90,
        ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: MyColors.grey_95,
    ),
    bottomAppBarTheme: const BottomAppBarTheme(color: MyColors.grey_95),
    appBarTheme: AppBarTheme(
      color: MyColors.primary,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    ),
    dividerColor: Colors.grey.shade800,
    //bottomAppBarTheme: BottomAppBarTheme(color: MyColors.grey_90),
    cardTheme: const CardTheme(
        //color: MyColors.grey_80,
        ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontFamily: 'WorkSans',
      ),
      titleSmall: TextStyle(
        color: Colors.white,
        fontFamily: 'WorkSans',
        fontSize: 18.0,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontFamily: 'WorkSans',
      ),
      displaySmall: TextStyle(
        color: Colors.white,
        fontFamily: 'WorkSans',
      ),
      displayMedium: TextStyle(
        color: Colors.white,
        fontFamily: 'WorkSans',
      ),
      displayLarge: TextStyle(
        color: Colors.white,
        fontFamily: 'WorkSans',
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontFamily: 'WorkSans',
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontFamily: 'WorkSans',
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontFamily: 'WorkSans',
      ),
      labelSmall: TextStyle(
        color: Colors.white,
      ),
      bodySmall: TextStyle(
        color: Colors.white,
      ),
    ),
  ),
};
