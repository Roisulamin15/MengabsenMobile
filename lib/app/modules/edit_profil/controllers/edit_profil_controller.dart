import 'package:flutter_application_mengabsen/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class EditProfilController extends GetxController {
  final storage = GetStorage();

  // Controller untuk field input
  final namaController = TextEditingController();
  final hpController = TextEditingController();
  final emailController = TextEditingController();
  final tglLahirController = TextEditingController();
  final ktpController = TextEditingController();
  final pasporController = TextEditingController();
  final alamatController = TextEditingController();

  // Dropdown & pilihan data
  var jenisKelamin = RxnString();
  var provinsi = RxnString();
  var kabupaten = RxnString();
  var kecamatan = RxnString();
  var kota = RxnString();

  @override
  void onInit() {
    super.onInit();
    _ambilDataDariStorage();
  }

  /// Ambil data dari GetStorage untuk mengisi form awal
  void _ambilDataDariStorage() {
    namaController.text = storage.read("nama") ?? "";
    hpController.text = storage.read("hp") ?? "";
    emailController.text = storage.read("email") ?? "";
    tglLahirController.text = storage.read("tglLahir") ?? "";
    ktpController.text = storage.read("ktp") ?? "";
    pasporController.text = storage.read("paspor") ?? "";
    alamatController.text = storage.read("alamat") ?? "";

    jenisKelamin.value = storage.read("jenisKelamin") ?? "";
    provinsi.value = storage.read("provinsi") ?? "";
    kabupaten.value = storage.read("kabupaten") ?? "";
    kecamatan.value = storage.read("kecamatan") ?? "";
    kota.value = storage.read("kota") ?? "";
  }

  /// Simpan data ke GetStorage
  void simpanData() {
    storage.write("nama", namaController.text);
    storage.write("hp", hpController.text);
    storage.write("email", emailController.text);
    storage.write("tglLahir", tglLahirController.text);
    storage.write("ktp", ktpController.text);
    storage.write("paspor", pasporController.text);
    storage.write("alamat", alamatController.text);

    storage.write("jenisKelamin", jenisKelamin.value ?? "");
    storage.write("provinsi", provinsi.value ?? "");
    storage.write("kabupaten", kabupaten.value ?? "");
    storage.write("kecamatan", kecamatan.value ?? "");
    storage.write("kota", kota.value ?? "");

    // Tampilkan notifikasi berhasil
    Get.snackbar(
      "Berhasil",
      "Data profil berhasil disimpan",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Perbarui HomeView otomatis setelah simpan
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().ambilDataPengguna();
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
