import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlamatSayaController extends GetxController {
  // Form controllers
  final alamatController = TextEditingController();
  final kodePosController = TextEditingController();

  // Dropdown selections
  var provinsi = ''.obs;
  var kabupaten = ''.obs;
  var kecamatan = ''.obs;
  var kelurahan = ''.obs;
  var statusKepemilikan = ''.obs;

  // Dummy data
  final List<String> provinsiList = ["DKI Jakarta", "Jawa Barat", "Jawa Tengah"];
  final List<String> kabupatenList = ["Jakarta Pusat", "Jakarta Barat", "Jakarta Selatan"];
  final List<String> kecamatanList = ["Gambir", "Menteng", "Tanah Abang"];
  final List<String> kelurahanList = ["Kelurahan A", "Kelurahan B", "Kelurahan C"];
  final List<String> statusList = ["Milik Sendiri", "Sewa", "Keluarga"];

  void simpanAlamat() {
    if (alamatController.text.isEmpty || provinsi.isEmpty || kabupaten.isEmpty) {
      _showError();
    } else {
      _showSuccess();
    }
  }

  void _showSuccess() {
    Get.dialog(
      AlertDialog(
        title: const Text("Data Berhasil Disimpan", style: TextStyle(color: Colors.orange)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check_circle, size: 50, color: Colors.green),
            SizedBox(height: 8),
            Text("Perubahan berhasil disimpan.\nSilahkan menunggu konfirmasi dari admin."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("OK", style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _showError() {
    Get.dialog(
      AlertDialog(
        title: const Text("Terjadi Kesalahan", style: TextStyle(color: Colors.red)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.error, size: 50, color: Colors.red),
            SizedBox(height: 8),
            Text("Terjadi kesalahan, coba lagi nanti"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("OK", style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    alamatController.dispose();
    kodePosController.dispose();
    super.onClose();
  }
}
