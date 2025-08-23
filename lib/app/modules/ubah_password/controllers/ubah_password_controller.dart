import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UbahPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isPasswordHidden = true.obs;
  var isConfirmHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmVisibility() {
    isConfirmHidden.value = !isConfirmHidden.value;
  }

  void simpanPasswordBaru() {
    if (passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      Get.snackbar("Error", "Semua kolom harus diisi");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "Password tidak sama");
      return;
    }

    // TODO: Tambahkan API call atau proses simpan password
    Get.snackbar("Berhasil", "Password berhasil diubah");
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
