import 'package:flutter/material.dart';
import 'package:get/get.dart';


class EditProfilController extends GetxController {
  // TextEditingController untuk setiap field
  final namaController = TextEditingController();
  final hpController = TextEditingController();
  final emailController = TextEditingController();
  final tglLahirController = TextEditingController();
  final ktpController = TextEditingController();
  final pasporController = TextEditingController();
  final alamatController = TextEditingController();

  // Dropdown values
  var jenisKelamin = RxnString();
  var provinsi = RxnString();
  var kabupaten = RxnString();
  var kecamatan = RxnString();
  var kota = RxnString();

  @override
  void onClose() {
    // pastikan controller di-dispose saat tidak dipakai
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
