import 'package:bde_esiee_mobile/src/App.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (context) => ThemeNotifier(),
      child: App(),
    ),
  );
}

