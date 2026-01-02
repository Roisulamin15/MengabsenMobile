import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_mengabsen/services/api_service.dart';
import 'package:flutter_application_mengabsen/app/routes/app_pages.dart';

class VerifikasiEmailController extends GetxController {
  final kodeController = TextEditingController();
  var isLoading = false.obs;

  String? email;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args == null || args is! Map || args['email'] == null) {
      Get.snackbar("Error", "Data tidak valid, silakan ulangi");
      Get.offAllNamed(Routes.LUPA_PASSWORD);
      return;
    }

    email = args['email'];
  }

  Future<void> verifikasiEmail() async {
    if (email == null) {
      Get.snackbar("Error", "Email tidak valid");
      return;
    }

    if (kodeController.text.trim().length != 6) {
      Get.snackbar("Error", "Kode OTP harus 6 digit");
      return;
    }

    try {
      isLoading.value = true;

      await ApiService.verifyOtp(
        email: email!,
        otp: kodeController.text.trim(),
      );

      Get.snackbar("Sukses", "OTP valid");

      Get.toNamed(
        Routes.UBAH_PASSWORD,
        arguments: {
          'email': email!,
          'otp': kodeController.text.trim(),
        },
      );
    } catch (e) {
      Get.snackbar("Error", "OTP salah atau kadaluarsa");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    kodeController.dispose();
    super.onClose();
  }
}
