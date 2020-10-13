import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MyTheme {
  static const PrimaryColorLight = const Color(0xFF296faa);
  static const PrimaryColorDark = const Color(0xFFFDFDFD);

  static const AccentColorLight = const Color(0xFF52C9ED);
  static const AccentColorDark = const Color(0xFF296faa);

  static const LightBackground = const Color(0xFFFDFDFD);
  static const DarkBackground = const Color(0xFF0e283d);

  static const WidgetBackgroundLight = const Color(0xFFFFFFFF);
  static const WidgetDarkBackground = const Color(0xFF296faa);

  static const SelectedColor = const Color(0xFFEC4D9C);

  static final ThemeData defaultTheme = _buildTheme();
  static final ThemeData darkTheme = _buildDarkTheme();

  static SetStatusBarColor(context) {
    if (Provider.of<AppStateNotifier>(context, listen: false).isDarkMode) {
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: DarkBackground,
            systemNavigationBarDividerColor: Colors.transparent,
          )
      );
    }
    else {
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.light.copyWith(
            statusBarColor: LightBackground,
            systemNavigationBarDividerColor: Colors.transparent,
          )
      );
    }
  }

  static ColorTheme(context, {Color colorLight, Color colorDark}) {
    return Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ?
    colorDark ?? PrimaryColorDark : colorLight ?? PrimaryColorLight;
  }

  static ColorDial(context,) {
    return Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ?
    DarkBackground : WidgetBackgroundLight;
  }

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

      appBarTheme: AppBarTheme(
        brightness: Brightness.light,
        elevation: 0.0,
        color: LightBackground,
        textTheme: TextTheme(
          title: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: PrimaryColorLight,),
        ),
      ),

      primaryIconTheme: IconThemeData(
          color: PrimaryColorLight
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: PrimaryColorLight,
        foregroundColor: LightBackground,
      ),

      dialogBackgroundColor: WidgetBackgroundLight,

      /*iconTheme: IconThemeData(
        color: PrimaryColorLight,
      ),*/

      /*






      tabBarTheme: TabBarTheme(
        labelColor: PrimaryColorLight,
      ),

      cardTheme: CardTheme(
        color: WidgetBackgroundLight,
      ),


       */
    );
  }

  static ThemeData _buildDarkTheme() {
    final ThemeData base = ThemeData.dark();

    return base.copyWith(
      primaryColor: PrimaryColorDark,
      backgroundColor: DarkBackground,
      accentColor: AccentColorDark,
      scaffoldBackgroundColor: DarkBackground,

      textSelectionColor: AccentColorDark,
      selectedRowColor: AccentColorDark,

      appBarTheme: AppBarTheme(
        brightness: Brightness.dark,
        elevation: 0.0,
        color: DarkBackground,
        textTheme: TextTheme(
          title: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: PrimaryColorDark,),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 5,
          backgroundColor: DarkBackground,
          selectedItemColor: SelectedColor
      ),

      cardTheme: CardTheme(
        color: WidgetDarkBackground.withOpacity(0.7),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: PrimaryColorDark,
        foregroundColor: SelectedColor,
      ),

      dialogBackgroundColor: DarkBackground,
/*
        primaryIconTheme: IconThemeData(
            color: PrimaryColorDark
        ),

        iconTheme: IconThemeData(
          color: PrimaryColorDark,
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

        dialogBackgroundColor: WidgetDarkBackground,*/
    );
  }
}

class AppStateNotifier extends ChangeNotifier {
  //
  bool isDarkMode = false;

  void updateTheme(bool isDarkMode) {
    this.isDarkMode = isDarkMode;
    notifyListeners();
  }
}