import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTheme {
  static const PrimaryColorLight = const Color(0xFF296faa);
  static const PrimaryColorDark = const Color(0xFFFDFDFD);

  static const AccentColorLight = const Color(0xFF52C9ED);
  static const AccentColorDark = const Color(0xFF296faa);

  static const LightBackground = const Color(0xFFFDFDFD);
  static const DarkBackground = const Color(0xFF0e283d);

  static const WidgetBackgroundLight = const Color(0xFFFFFFFF);
  static const WidgetDarkBackground = const Color(0xFF184366);

  static const SelectedColor = const Color(0xFFEC4D9C);

  static final ThemeData defaultTheme = _buildTheme();
  static final ThemeData darkTheme = _buildDarkTheme();

  static ThemeData _buildTheme() {
    final ThemeData base = ThemeData.light();

    return base.copyWith(
      primaryColor: PrimaryColorLight,
      accentColor: AccentColorLight,
      backgroundColor: LightBackground,
      scaffoldBackgroundColor: LightBackground,
      canvasColor: LightBackground,

      textSelectionColor: AccentColorLight,
      selectedRowColor: AccentColorLight,

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: PrimaryColorLight,
        foregroundColor: LightBackground,
      ),

      appBarTheme: AppBarTheme(
        brightness: Brightness.light,
        elevation: 0.0,
        color: LightBackground,
        textTheme: TextTheme(
          title: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: PrimaryColorLight,),
        ),
      ),

      primaryIconTheme: IconThemeData(
          color: PrimaryColorLight
      ),

      iconTheme: IconThemeData(
        color: PrimaryColorLight,
      ),

      tabBarTheme: TabBarTheme(
        labelColor: PrimaryColorLight,
      ),

      cardTheme: CardTheme(
        color: WidgetBackgroundLight,
      ),

      dialogBackgroundColor: WidgetBackgroundLight,
    );
  }

  static ThemeData _buildDarkTheme() {
    final ThemeData base = ThemeData.dark();

    return base.copyWith(
        primaryColor: PrimaryColorDark,
        backgroundColor: DarkBackground,
        scaffoldBackgroundColor: DarkBackground,

        textSelectionColor: AccentColorDark,
        selectedRowColor: AccentColorDark,

        primaryIconTheme: IconThemeData(
            color: PrimaryColorDark
        ),

        iconTheme: IconThemeData(
          color: PrimaryColorDark,
        ),

        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          elevation: 1.0,
          color: DarkBackground,
          textTheme: TextTheme(
            title: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: PrimaryColorDark,),
          ),
        ),

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: PrimaryColorDark,
          foregroundColor: DarkBackground,
        ),

        tabBarTheme: TabBarTheme(
          labelColor: PrimaryColorDark,
        ),

        cardTheme: CardTheme(
          color: WidgetDarkBackground,
        ),

        textTheme: TextTheme(
          caption: TextStyle(color: Colors.white),
        ),

        dialogBackgroundColor: WidgetDarkBackground,
    );
  }
}