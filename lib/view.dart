import 'package:flutter/material.dart';
import 'package:tanda_vital_flutter/pasien.dart';
import 'package:tanda_vital_flutter/utils.dart';

class LihatPasien extends StatefulWidget {
  final PasienData data;

  LihatPasien({@required this.data});

  @override
  _LihatPasienState createState() => _LihatPasienState();
}

class _LihatPasienState extends State<LihatPasien> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Utils.genderPrefix(this.widget.data)),
      ),
      body: Container(),
    );
  }
}