import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  final storage = GetStorage();

  var nama = "Pengguna".obs;
  var jabatan = "Karyawan".obs;

  var absenHariIni = <Map<String, String>>[].obs;
  var absenKemarin = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    ambilDataPengguna();
    _loadAbsenDummy();
  }

  void ambilDataPengguna() {
    // ambil data user hasil login
    nama.value = storage.read("nama") ?? "Pengguna";
    jabatan.value = storage.read("jabatan") ?? "Karyawan";
  }

  void _loadAbsenDummy() {
    absenHariIni.assignAll([
      {
        "jenis": "Masuk",
        "jam": "09:00 WIB",
        "tanggal": "Selasa, 13 Mei 2023",
        "status": "Sudah Absen",
      },
      {
        "jenis": "Pulang",
        "jam": "17:30 WIB",
        "tanggal": "Selasa, 13 Mei 2023",
        "status": "Sudah Absen",
      },
    ]);

    absenKemarin.assignAll([
      {
        "jenis": "Masuk",
        "jam": "09:05 WIB",
        "tanggal": "Senin, 12 Mei 2023",
        "status": "Sudah Absen",
      },
      {
        "jenis": "Pulang",
        "jam": "17:30 WIB",
        "tanggal": "Senin, 12 Mei 2023",
        "status": "Sudah Absen",
      },
    ]);
  }
}
