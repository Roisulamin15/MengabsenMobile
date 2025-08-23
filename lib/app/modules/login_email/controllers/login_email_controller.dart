import 'package:flutter_application_mengabsen/services/api_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../home/views/home_view.dart';

class LoginEmailController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var rememberMe = true.obs;
  var token = "".obs;

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email dan password wajib diisi",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      final data = await ApiService.login(email, password);

      if (data['success'] == true) {
        token.value = data['token'];

        // Jika login berhasil, pindah ke HomeView (Dashboard)
        Get.off(() => HomeView());
      } else {
        // Kalau gagal, tampilkan pesan dari backend
        Get.snackbar("Login Gagal", data['message'] ?? "Terjadi kesalahan",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Tidak bisa terhubung ke server",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
