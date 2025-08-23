import 'package:flutter/material.dart';
import 'package:flutter_application_mengabsen/app/routes/app_pages.dart';
import 'package:get/get.dart';
import '../controllers/lupa_password_controller.dart';

class LupaPasswordView extends GetView<LupaPasswordController> {
  const LupaPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lupa Password"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Silahkan Masukan Email yang sudah terdaftar",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Input Email
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.email_outlined, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: controller.emailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Masukan Email Anda",
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Tombol Kirim
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),  
                ),
                onPressed: () {
                  controller.kirimEmail();
                  Get.toNamed(Routes.VERIFIKASI_EMAIL);
                },
                child: const Text(
                  "Kirim",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
