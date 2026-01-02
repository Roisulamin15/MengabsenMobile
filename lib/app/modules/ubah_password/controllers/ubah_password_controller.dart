import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_mengabsen/services/api_service.dart';
import '../../../routes/app_pages.dart';

class UbahPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? email;
  String? otp;

  var isLoading = false.obs;

  // ✅ TAMBAHKAN INI
  var isPasswordHidden = true.obs;
  var isConfirmHidden = true.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args == null || args is! Map) {
      Get.offAllNamed(Routes.LUPA_PASSWORD);
      return;
    }

    email = args['email'];
    otp = args['otp'];

    if (email == null || otp == null) {
      Get.offAllNamed(Routes.LUPA_PASSWORD);
    }
  }

  // ✅ TAMBAHKAN INI
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmVisibility() {
    isConfirmHidden.value = !isConfirmHidden.value;
  }

  Future<void> simpanPasswordBaru() async {
    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar("Error", "Password tidak boleh kosong");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "Password tidak sama");
      return;
    }

    try {
      isLoading.value = true;

      await ApiService.resetPassword(
        email: email!,
        otp: otp!,
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
      );

      Get.snackbar("Berhasil", "Password berhasil diubah");
      Get.offAllNamed(Routes.LOGIN_EMAIL);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
