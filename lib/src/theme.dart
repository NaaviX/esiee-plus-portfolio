import 'package:flutter/material.dart';

const PrimaryColor = const Color(0xFF296faa);
const PrimaryColorLight = const Color(0xFF296faa);
const PrimaryColorDark = const Color(0xFF161F2D);

const SecondaryColor = const Color(0xFF52C9ED);
const SecondaryColorLight = const Color(0xFF52C9ED);
const SecondaryColorDark = const Color(0xFF296FAA);

const TertiaryColor = const Color(0xFFEC4D9C);
const TertiaryColorLight = const Color(0xFFEC4D9C);
const TertiaryColorDark = const Color(0xFFBC3D7C);

const Background = const Color(0xFFFDFDFD);
const WidgetBackground = const Color(0xFFFFFFFF);
const TextColor = const Color(0xFF000000);

class MyTheme {
  static final ThemeData defaultTheme = _buildTheme();

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
        buttonColor: SecondaryColor,
        textTheme: ButtonTextTheme.primary,
      ),

      scaffoldBackgroundColor: Background,
      cardColor: WidgetBackground,
      dialogBackgroundColor: WidgetBackground,
      textSelectionColor: PrimaryColorLight,
      backgroundColor: Background,
      bottomAppBarColor: WidgetBackground,

      textTheme: base.textTheme.copyWith(
        headline1: TextStyle(),
      ),
    );
  }
}