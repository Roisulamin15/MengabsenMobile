import 'package:get/get.dart';

class PilihBahasaController extends GetxController {
  // Default bahasa Indonesia
  var selectedLanguage = 'id'.obs;

  void setLanguage(String langCode) {
    selectedLanguage.value = langCode;
    // TODO: di sini nanti bisa ditambahkan logika ganti bahasa di seluruh app
  }
}
