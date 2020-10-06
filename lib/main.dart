import 'package:bde_esiee_mobile/src/App.dart';
import 'package:bde_esiee_mobile/src/blocs/simple_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
void main() {
  Bloc.observer = SimpleBlocObserver();

  runApp(MaterialApp(home: App()));
}

