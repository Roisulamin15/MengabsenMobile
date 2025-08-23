import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/verifikasi_email_controller.dart';
import 'package:flutter_application_mengabsen/app/routes/app_pages.dart';

class VerifikasiEmailView extends GetView<VerifikasiEmailController> {
  const VerifikasiEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verifikasi Email"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Masukkan kode verifikasi yang telah dikirim ke email Anda",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Input kode verifikasi
            TextField(
              controller: controller.kodeController,
              decoration: InputDecoration(
                hintText: "Masukkan kode",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 32),

            // Tombol Verifikasi
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
                  // Arahkan ke halaman ubah password
                  Get.toNamed(Routes.UBAH_PASSWORD);
                },
                child: const Text(
                  "Verifikasi",
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
