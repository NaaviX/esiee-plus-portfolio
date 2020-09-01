import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


const PrimaryColorLight = const Color(0xFF296faa);
const PrimaryColorDark = const Color(0xFF1A91DA);

const AccentColorLight = const Color(0xFF52C9ED);
const AccentColorDark = const Color(0xFF296faa);

const LightBackground = const Color(0xFFFDFDFD);
const DarkBackground = const Color(0xFF0e283d);

const WidgetBackgroundLight = const Color(0xFFFFFFFF);
const WidgetDarkBackground = const Color(0xFF184366);

class MyTheme {
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
        )
    );
  }
}