import 'package:flutter/material.dart';

const PrimaryColor = const Color(0xFF296faa);
const PrimaryColorLight = const Color(0xFF296faa);
const PrimaryColorDark = const Color(0xFF296faa);

const SecondaryColor = const Color(0xFF52C9ED);
const SecondaryColorLight = const Color(0xFF52C9ED);
const SecondaryColorDark = const Color(0xFF296FAA);

const TertiaryColor = const Color(0xFFEC4D9C);
const TertiaryColorLight = const Color(0xFFEC4D9C);
const TertiaryColorDark = const Color(0xFFBC3D7C);

const Background = const Color(0xFFFDFDFD);
const DarkBackground = const Color(0xFFF15202B);
const WidgetBackground = const Color(0xFFFFFFFF);
const WidgetDarkBackground = const Color(0xFF0e283d);
const Black = const Color(0xFF000000);
const White = const Color(0xFFFFFFFF);

class MyTheme {
  static final ThemeData defaultTheme = _buildTheme();
  static final ThemeData darkTheme = _buildDarkTheme();

  static ThemeData _buildTheme() {
    final ThemeData base = ThemeData.light();

    return base.copyWith(
      accentColor: SecondaryColor,
      accentColorBrightness: Brightness.dark,

      primaryColor: PrimaryColor,
      primaryColorDark: PrimaryColorDark,
      primaryColorLight: PrimaryColorLight,
        primaryColorBrightness: Brightness.dark,

      selectedRowColor: SecondaryColor,

      buttonTheme: base.buttonTheme.copyWith(

      ),

      cardTheme: base.cardTheme.copyWith(
        color: WidgetBackground,

      ),

      dialogTheme: base.dialogTheme.copyWith(

      ),

      chipTheme: base.chipTheme.copyWith(

      ),

      floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(

      ),

      primaryIconTheme: base.primaryIconTheme.copyWith(
        color: White,
        size: 20,
      ),

      scaffoldBackgroundColor: Background,
      textSelectionColor: PrimaryColorLight,
      backgroundColor: Background,

      textTheme: base.textTheme.copyWith(
        bodyText2: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        subtitle1: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    );
  }

  static ThemeData _buildDarkTheme() {
    final ThemeData base = ThemeData.dark();

    return base.copyWith(
      accentColor: SecondaryColor,
      accentColorBrightness: Brightness.dark,

      primaryColor: PrimaryColorDark,
      primaryColorDark: PrimaryColorDark,
      primaryColorLight: PrimaryColorLight,
      primaryColorBrightness: Brightness.dark,

      selectedRowColor: SecondaryColor,
    );
  }
}