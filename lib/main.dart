import 'package:flutter/material.dart';
import './home.dart';

class TandaVitalApp extends StatelessWidget {
  final appTitle = 'Dokumentasi Tanda Vital';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: this.appTitle,
      home: Home(),
      theme: ThemeData(
        primarySwatch: Colors.teal
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  runApp(TandaVitalApp());
}
