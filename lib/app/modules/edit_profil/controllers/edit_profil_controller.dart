import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../home/controllers/home_controller.dart';

class EditProfilController extends GetxController {
  final storage = GetStorage();
  final picker = ImagePicker();

  // Text controllers
  final namaController = TextEditingController();
  final hpController = TextEditingController();
  final emailController = TextEditingController();
  final tglLahirController = TextEditingController();
  final ktpController = TextEditingController();
  final pasporController = TextEditingController();
  final alamatController = TextEditingController();

  // Dropdowns
  var jenisKelamin = RxnString();
  var kelurahan = RxnString();
  var kecamatan = RxnString();
  var kota = RxnString();
  var provinsi = RxnString();

  // User data
  var username = "".obs;
  var role = "".obs;
  var fotoProfil = "".obs;

  final baseUrl = "https://cmsweb-production.up.railway.app/api";

  @override
  void onInit() {
    super.onInit();
    _ambilDataDariStorage();
    ambilProfileDariAPI();
  }

  void _ambilDataDariStorage() {
    namaController.text = storage.read("nama_lengkap") ?? "";
    hpController.text = storage.read("no_hp") ?? "";
    tglLahirController.text = storage.read("tanggal_lahir") ?? "";
    ktpController.text = storage.read("nik") ?? "";
    pasporController.text = storage.read("no_passport") ?? "";
    alamatController.text = storage.read("alamat") ?? "";

    jenisKelamin.value = storage.read("jenis_kelamin");
    kelurahan.value = storage.read("kelurahan");
    kecamatan.value = storage.read("kecamatan");
    kota.value = storage.read("kota");
    provinsi.value = storage.read("provinsi");

    username.value = storage.read("username") ?? "Pengguna";
    role.value = storage.read("role") ?? "User";
    fotoProfil.value = storage.read("fotoProfil") ?? "";
  }

  Future<void> ambilProfileDariAPI() async {
    try {
      final token = storage.read("token");
      if (token == null) return;

      final response = await http.get(
        Uri.parse("$baseUrl/profile"),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final profile = data['profile'];
        if (profile != null) {
          _isiDataKeController(profile);
          _simpanKeStorage(profile);
        }
      } else {
        debugPrint("Gagal ambil profil (${response.statusCode}): ${response.body}");
      }
    } catch (e) {
      debugPrint("Error ambil profil: $e");
    }
  }

  Future<void> simpanData() async {
    Get.snackbar("Menyimpan...", "Mengirim data ke server...",
        snackPosition: SnackPosition.BOTTOM);

    try {
      final token = storage.read("token");
      if (token == null) {
        _showResultDialog(success: false, message: "Token tidak ditemukan. Silakan login ulang.");
        return;
      }

      final Map<String, String> body = {};

      void addField(String key, String? value) {
        if (value != null && value.trim().isNotEmpty) {
          body[key] = value.trim();
        }
      }

      addField("nama_lengkap", namaController.text);
      addField("no_hp", hpController.text);
      addField("jenis_kelamin", jenisKelamin.value);
      addField("nik", ktpController.text);
      addField("no_passport", pasporController.text);
      addField("alamat", alamatController.text);
      addField("kelurahan", kelurahan.value);
      addField("kecamatan", kecamatan.value);
      addField("kota", kota.value);
      addField("provinsi", provinsi.value);

      if (tglLahirController.text.isNotEmpty) {
        try {
          final parsed = DateTime.parse(tglLahirController.text);
          body["tanggal_lahir"] =
              "${parsed.year.toString().padLeft(4, '0')}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}";
        } catch (_) {}
      }

      final response = await http.post(
        Uri.parse("$baseUrl/profile/update"),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        final profile = res['profile'];
        _isiDataKeController(profile);
        _simpanKeStorage(profile);

        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().ambilDataPengguna();
        }

        _showResultDialog(
          success: true,
          message: "Perubahan berhasil disimpan.\nKamu bisa mengganti lagi di edit profil.",
        );
      } else {
        final res = jsonDecode(response.body);
        final msg = res['message'] ?? 'Terjadi kesalahan saat memperbarui profil.';
        _showResultDialog(success: false, message: msg);
      }
    } catch (e) {
      _showResultDialog(success: false, message: "Terjadi kesalahan, coba lagi nanti.");
    }
  }

  void _showResultDialog({required bool success, required String message}) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header warna
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: success ? const Color(0xFFFF8A00) : const Color(0xFFFF4D4D),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  success ? "Data Berhasil Disimpan" : "Terjadi Kesalahan",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Icon(
                success ? Icons.check_circle : Icons.error,
                size: 80,
                color: success ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 20),

              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.offNamed('/profil');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: success
                        ? const Color(0xFFFF8A00)
                        : const Color(0xFFFF4D4D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _simpanKeStorage(Map profile) {
    profile.forEach((key, value) {
      storage.write(key, value ?? "");
    });
  }

  void _isiDataKeController(Map profile) {
    namaController.text = profile['nama_lengkap'] ?? "";
    hpController.text = profile['no_hp'] ?? "";
    tglLahirController.text = profile['tanggal_lahir'] ?? "";
    jenisKelamin.value = profile['jenis_kelamin'] ?? "";
    ktpController.text = profile['nik'] ?? "";
    pasporController.text = profile['no_passport'] ?? "";
    alamatController.text = profile['alamat'] ?? "";
    kelurahan.value = profile['kelurahan'] ?? "";
    kecamatan.value = profile['kecamatan'] ?? "";
    kota.value = profile['kota'] ?? "";
    provinsi.value = profile['provinsi'] ?? "";
  }

  Future<void> pilihFoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      fotoProfil.value = pickedFile.path;
      storage.write("fotoProfil", pickedFile.path);
    }
  }

  @override
  void onClose() {
    namaController.dispose();
    hpController.dispose();
    emailController.dispose();
    tglLahirController.dispose();
    ktpController.dispose();
    pasporController.dispose();
    alamatController.dispose();
    super.onClose();
  }
}
