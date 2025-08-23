import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LupaPasswordController extends GetxController {
  final emailController = TextEditingController();

  void kirimEmail() {
    if (emailController.text.isEmpty) {
      Get.snackbar("Error", "Email tidak boleh kosong");
    } else {
      // Tambahkan logika kirim email di sini
      Get.snackbar("Berhasil", "Email reset password telah dikirim");
    }
  }
}
