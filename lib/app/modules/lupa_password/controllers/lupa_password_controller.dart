import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_mengabsen/services/api_service.dart';
import 'package:flutter_application_mengabsen/app/routes/app_pages.dart';

class LupaPasswordController extends GetxController {
  final emailController = TextEditingController();
  final isLoading = false.obs;

  Future<void> kirimEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        "Error",
        "Email tidak boleh kosong",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      // 🔥 Panggil API
      await ApiService.forgotPassword(email);

      Get.snackbar(
        "Berhasil",
        "OTP dikirim ke email",
        snackPosition: SnackPosition.BOTTOM,
      );

      // 🔥 NAVIGASI + KIRIM EMAIL (WAJIB MAP)
      Get.toNamed(
        Routes.VERIFIKASI_EMAIL,
        arguments: {
          'email': email,
        },
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
