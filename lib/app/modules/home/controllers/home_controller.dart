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
    nama.value = storage.read("nama") ?? "Pengguna";
    jabatan.value = storage.read("jabatan") ?? "Karyawan";
  }

  void _loadAbsenDummy() {
    absenHariIni.assignAll([
      {
        "jam": "08:05",
        "tanggal": "24 Agustus 2025",
        "status": "Masuk",
      },
    ]);

    absenKemarin.assignAll([
      {
        "jam": "08:10",
        "tanggal": "23 Agustus 2025",
        "status": "Masuk",
      },
    ]);
  }
}
