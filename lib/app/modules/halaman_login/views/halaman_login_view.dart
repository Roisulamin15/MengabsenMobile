import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/halaman_login_controller.dart';
import '../../../routes/app_pages.dart';

class HalamanLoginView extends GetView<HalamanLoginController> {
  const HalamanLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // Biar layout ikut naik kalau keyboard muncul
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              // Scroll supaya aman di layar kecil
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      // Logo fingerprint + MengABSEN
                      const SizedBox(height: 35),
                      Image.asset(
                        'assets/Mengabsen.png',
                        height: 100,
                      ),

                      // Orang jalan di globe
                      const SizedBox(height: 75),
                      Image.asset(
                        'assets/Ilustrasi.png',
                        height: 250,
                      ),

                      // Card Pendaftaran
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Daftar',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Buat profil, pilih pesananmu, bayar dan mulai perjalananmu',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.toNamed(Routes.LOGIN_EMAIL);
                                  },
                                  icon: const Icon(Icons.email_outlined,
                                      color: Colors.white),
                                  label: const Text(
                                    'Email',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Logo IOTA + powered by
                                Column(
                                  children: [
                                    Image.asset(
                                      'assets/logo_kecil.png',
                                      height: 30,
                                    ),
                                    const SizedBox(height: 5),
                                    Image.asset(
                                      'assets/Powerby.png',
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
