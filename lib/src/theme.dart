import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const PrimaryColor = const Color(0xFF296faa);
const PrimaryColorLight = const Color(0xFF296faa);
const PrimaryColorDark = const Color(0xFF1a2e43);

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
      primaryColor: PrimaryColor,
      backgroundColor: Background,
      scaffoldBackgroundColor: Background,

      textSelectionColor: SecondaryColor,
      selectedRowColor: SecondaryColor,

      primaryIconTheme: IconThemeData(
        color: PrimaryColor
      ),

      iconTheme: IconThemeData(
        color: PrimaryColor,
      ),

      appBarTheme: AppBarTheme(
        elevation: 1.0,
        color: Background,
        textTheme: TextTheme(
          title: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: PrimaryColor,),
        ),
      ),

      tabBarTheme: TabBarTheme(
        labelColor: PrimaryColor,
      ),

      cardTheme: CardTheme(
        color: WidgetBackground,
      ),
    );
  }

  static ThemeData _buildDarkTheme() {
    final ThemeData base = ThemeData.dark();

    return base.copyWith(
      primaryColor: PrimaryColorDark,
      backgroundColor: DarkBackground,
      scaffoldBackgroundColor: DarkBackground,

      textSelectionColor: SecondaryColorDark,
      selectedRowColor: SecondaryColorDark,

      primaryIconTheme: IconThemeData(
          color: PrimaryColor
      ),

      iconTheme: IconThemeData(
        color: PrimaryColor,
      ),

      appBarTheme: AppBarTheme(
        elevation: 1.0,
        color: DarkBackground,
        textTheme: TextTheme(
          title: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: PrimaryColor,),
        ),
      ),

      tabBarTheme: TabBarTheme(
        labelColor: PrimaryColor,
      ),

      cardTheme: CardTheme(
        color: WidgetDarkBackground,
      ),

      textTheme: TextTheme(
        caption: TextStyle(color: White),
      )
    );
  }
}