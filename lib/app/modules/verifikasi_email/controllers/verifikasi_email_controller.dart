import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifikasiEmailController extends GetxController {
  final TextEditingController kodeController = TextEditingController();
  var isLoading = false.obs;

  void verifikasiEmail() {
    if (kodeController.text.length != 6) {
      Get.snackbar("Error", "Masukkan 6 digit kode verifikasi");
      return;
    }

    isLoading.value = true;

    Future.delayed(Duration(seconds: 2), () {
      isLoading.value = false;
      Get.snackbar("Sukses", "Email berhasil diverifikasi");
    });
  }

  void kirimUlangEmail() {
    Get.snackbar("Info", "Kode verifikasi telah dikirim ulang ke email Anda");
  }
}
