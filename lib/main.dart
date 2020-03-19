import 'package:flutter/material.dart';
import 'package:tanda_vital_flutter/home.dart';

class TandaVitalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home();
  }
}

class App extends StatelessWidget {
  final appTitle = 'Dokumentasi Tanda Vital';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: this.appTitle,
      home: TandaVitalApp(),
      theme: ThemeData(
        primarySwatch: Colors.green,
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.primary
        )
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  runApp(App());
}
