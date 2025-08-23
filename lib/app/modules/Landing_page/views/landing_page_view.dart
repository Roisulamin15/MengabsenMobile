import 'package:flutter/material.dart';
import 'package:flutter_application_mengabsen/app/routes/app_pages.dart';
import 'package:get/get.dart';
import '../controllers/landing_page_controller.dart';

class LandingPage extends GetView<LandingPageController> {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // GestureDetector untuk deteksi klik di seluruh layar
        child: GestureDetector(
          behavior: HitTestBehavior.opaque, // supaya area kosong juga terdeteksi
          onTap: () {
            Get.toNamed(Routes.HALAMAN_LOGIN); // arahkan ke halaman login
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 50),

              // Bagian Logo & Nama Perusahaan
              Column(
                children: [
                  // Logo
                  Image.asset(
                    'assets/logo_iota.png', // ganti path logo
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                ],
              ),

              // Ilustrasi di bawah
              Image.asset(
                'assets/meating.png', // ganti ilustrasi
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
