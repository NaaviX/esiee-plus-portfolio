import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTheme {
  static const PrimaryColorLight = const Color(0xFF296faa);
  static const PrimaryColorDark = const Color(0xFFFDFDFD);

  static const AccentColorLight = const Color(0xFF52C9ED);

  static const LightBackground = const Color(0xFFFDFDFD);
  static const DarkBackground = const Color(0xFF0e283d);

  static const WidgetBackgroundLight = const Color(0xFFFFFFFF);
  static const WidgetDarkBackground = const Color(0xFF296faa);

  static const SelectedColor = const Color(0xFFEC4D9C);

  static final ThemeData defaultTheme = _buildTheme();
  static final ThemeData darkTheme = _buildDarkTheme();

  static setStatusBarColor() async {
    final String key = "theme";
    SharedPreferences _preferences;
    if(_preferences == null)
      _preferences = await SharedPreferences.getInstance();
    bool _dark = _preferences.getBool(key) ?? false;

    if (_dark) {
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

  static colorTheme(context, {Color colorLight, Color colorDark}) {
    return Provider.of<ThemeNotifier>(context, listen: false).isDarkMode ?
    colorDark ?? PrimaryColorDark : colorLight ?? PrimaryColorLight;
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
        selectedRowColor: PrimaryColorLight,

        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          elevation: 0.0,
          color: LightBackground,
          textTheme: TextTheme(
            headline6: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: PrimaryColorLight,),
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

        tabBarTheme: TabBarTheme(
          labelColor: PrimaryColorLight,
          indicator: BoxDecoration(border: Border(bottom: BorderSide(color: PrimaryColorLight, width: 2))),
        ),
    );
  }

  static ThemeData _buildDarkTheme() {
    final ThemeData base = ThemeData.dark();

    return base.copyWith(
        primaryColor: PrimaryColorDark,
        backgroundColor: DarkBackground,
        accentColor: SelectedColor,
        scaffoldBackgroundColor: DarkBackground,

        textSelectionColor: SelectedColor,
        selectedRowColor: SelectedColor,

        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          elevation: 0.0,
          color: DarkBackground,
          textTheme: TextTheme(
            headline6: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: PrimaryColorDark,),
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

        tabBarTheme: TabBarTheme(
          labelColor: PrimaryColorDark,
          indicator: BoxDecoration(border: Border(bottom: BorderSide(color: SelectedColor, width: 2))),
        ),
    );
  }
}

class ThemeNotifier extends ChangeNotifier {

  final String key = "theme";
  SharedPreferences _preferences;
  bool _darkMode = false;
  bool isDarkMode = false;

  bool get darkMode => _darkMode;

  ThemeNotifier() {
    _darkMode = false;
    _loadFromPreferences();
    MyTheme.setStatusBarColor();
  }

  _initialPreferences() async {
    if(_preferences == null)
      _preferences = await SharedPreferences.getInstance();
  }

  _savePreferences()async {
    await _initialPreferences();
    _preferences.setBool(key, _darkMode);
  }

  _loadFromPreferences() async {
    await _initialPreferences();
    _darkMode = _preferences.getBool(key) ?? false;
    isDarkMode = _preferences.getBool(key) ?? false;
    notifyListeners();
  }

  toggleChangeTheme() {
    isDarkMode = !isDarkMode;
    _darkMode = !_darkMode;
    _savePreferences();
    notifyListeners();
  }
}