import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ganti_password_controller.dart';

class GantiPasswordView extends GetView<GantiPasswordController> {
  const GantiPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ganti Password", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Password akan diganti dengan password baru",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Password Lama
            Obx(() => TextField(
              controller: controller.oldPasswordController,
              obscureText: !controller.isOldPasswordVisible.value,
              decoration: InputDecoration(
                hintText: "Masukan Password Lama",
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isOldPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: controller.toggleOldPasswordVisibility,
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            )),
            const SizedBox(height: 15),

            // Password Baru
            Obx(() => TextField(
              controller: controller.newPasswordController,
              obscureText: !controller.isNewPasswordVisible.value,
              onChanged: controller.validatePassword,
              decoration: InputDecoration(
                hintText: "Masukan Password Baru",
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isNewPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: controller.toggleNewPasswordVisibility,
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            )),
            const SizedBox(height: 15),

            // Konfirmasi Password
            Obx(() => TextField(
              controller: controller.confirmPasswordController,
              obscureText: !controller.isConfirmPasswordVisible.value,
              decoration: InputDecoration(
                hintText: "Konfirmasi Password Baru",
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isConfirmPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: controller.toggleConfirmPasswordVisibility,
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            )),
            const SizedBox(height: 10),

            // Validasi
            Obx(() => Column(
              children: [
                Row(
                  children: [
                    Icon(
                      controller.isLengthValid.value ? Icons.check_circle : Icons.cancel,
                      color: controller.isLengthValid.value ? Colors.green : Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "6 karakter",
                      style: TextStyle(
                        color: controller.isLengthValid.value ? Colors.green : Colors.red,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      controller.isCombinationValid.value ? Icons.check_circle : Icons.cancel,
                      color: controller.isCombinationValid.value ? Colors.green : Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Kombinasi huruf besar, kecil & angka",
                      style: TextStyle(
                        color: controller.isCombinationValid.value ? Colors.green : Colors.red,
                      ),
                    )
                  ],
                ),
              ],
            )),

            const Spacer(),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: controller.savePassword,
                child: const Text("Simpan", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
