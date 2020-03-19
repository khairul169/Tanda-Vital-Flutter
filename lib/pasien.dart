import 'package:flutter/widgets.dart';

class PasienData {
  final int id;
  final String name;
  final int age;
  final int gender;
  final String regNumber;

  PasienData({
    this.id,
    @required this.name,
    this.age = -1,
    this.gender = 0,
    this.regNumber = '0000',
  });
}
