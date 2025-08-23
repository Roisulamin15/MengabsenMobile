import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GantiPasswordController extends GetxController {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isOldPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  var isLengthValid = false.obs;
  var isCombinationValid = false.obs;

  void toggleOldPasswordVisibility() =>
      isOldPasswordVisible.value = !isOldPasswordVisible.value;
  void toggleNewPasswordVisibility() =>
      isNewPasswordVisible.value = !isNewPasswordVisible.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  void validatePassword(String password) {
    isLengthValid.value = password.length >= 6;
    isCombinationValid.value = RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d!@#\$&*~]+$')
        .hasMatch(password);
  }

  void savePassword() {
    if (!isLengthValid.value || !isCombinationValid.value) {
      Get.snackbar("Error", "Password belum memenuhi kriteria",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "Konfirmasi password tidak cocok",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // POPUP SUKSES PERSIS SEPERTI GAMBAR
    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header orange
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: const Center(
                child: Text(
                  "Data Berhasil Disimpan",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Isi dialog
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  const Icon(Icons.check_circle,
                      size: 70, color: Colors.green),
                  const SizedBox(height: 16),
                  const Text(
                    "Perubahan berhasil disimpan\nkamu bisa mengganti lagi nanti.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => Get.back(),
                      child: const Text(
                        "OK",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
