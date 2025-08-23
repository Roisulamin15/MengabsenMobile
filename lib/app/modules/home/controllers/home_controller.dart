import 'package:get/get.dart';

class HomeController extends GetxController {
  var nama = "Muhammad Roisul Amin".obs;
  var jabatan = "Karyawan".obs;

  var absenHariIni = [
    {"tanggal": "Selasa, 13 May 2023", "jam": "Masuk 09.00 WIB", "status": "Sudah Absen"},
    {"tanggal": "Selasa, 13 May 2023", "jam": "Pulang 17.30 WIB", "status": "Sudah Absen"},
  ].obs;

  var absenKemarin = [
    {"tanggal": "Senin, 12 May 2023", "jam": "Masuk 09.00 WIB", "status": "Sudah Absen"},
    {"tanggal": "Senin, 12 May 2023", "jam": "Pulang 17.30 WIB", "status": "Sudah Absen"},
  ].obs;
}
