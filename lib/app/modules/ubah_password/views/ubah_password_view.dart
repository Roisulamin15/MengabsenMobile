import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ubah_password_controller.dart';

class UbahPasswordView extends GetView<UbahPasswordController> {
  const UbahPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Password Baru"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Obx(() => TextField(
              controller: controller.passwordController,
              obscureText: controller.isPasswordHidden.value,
              decoration: InputDecoration(
                hintText: "Password Baru",
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordHidden.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            )),
            const SizedBox(height: 16),
            Obx(() => TextField(
              controller: controller.confirmPasswordController,
              obscureText: controller.isConfirmHidden.value,
              decoration: InputDecoration(
                hintText: "Konfirmasi Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isConfirmHidden.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: controller.toggleConfirmVisibility,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            )),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: controller.simpanPasswordBaru,
                child: const Text("Simpan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
