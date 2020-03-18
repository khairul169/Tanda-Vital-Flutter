import 'package:tanda_vital_flutter/pasien.dart';

class Utils {
  static String genderPrefix(PasienData pasien) {
    String prefix = "";

    if (pasien.age < 5) {
      prefix = "By.";
    } else if (pasien.age <= 15) {
      prefix = "An.";
    } else {
      prefix = (pasien.gender == 1) ? "Ny." : "Tn.";
    }

    return prefix + " " + pasien.name;
  }
}
