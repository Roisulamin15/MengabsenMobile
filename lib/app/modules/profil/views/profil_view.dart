import 'package:flutter/material.dart';
import 'package:flutter_application_mengabsen/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'dart:io';

class ProfilView extends StatelessWidget {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color iconColor = Colors.black; // icon hitam
    const Color textColor = Colors.grey; // teks abu-abu

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Akun Saya",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Card Profil
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("assets/izul.jpg"),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Halo, Muhammad Roisul Amin",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Jakarta, Indonesia",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed(Routes.EDIT_PROFIL);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Edit"),
                  ),
                ],
              ),
            ),

            // Menu Pengaturan
            buildMenuItem(Icons.lock, "Ganti Password", () {
              Get.toNamed(Routes.GANTI_PASSWORD);
            }, iconColor, textColor),
            buildMenuItem(Icons.language, "Bahasa", () {
              Get.toNamed(Routes.PILIH_BAHASA);
            }, iconColor, textColor),
           buildMenuItem(Icons.location_on, "Alamat saya", () {
              Get.toNamed(Routes.ALAMAT_SAYA);
            }, iconColor, textColor),
            buildMenuItem(Icons.privacy_tip, "Kebijakan Privasi", () {}, iconColor, textColor),
            buildMenuItem(Icons.rule, "Syarat dan Ketentuan", () {}, iconColor, textColor),
            const Divider(),
            buildMenuItem(Icons.logout, "Logout", () {
              _showLogoutDialog(context);
            }, iconColor, textColor),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(
      IconData icon, String title, VoidCallback onTap, Color iconColor, Color textColor) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: const [
            Icon(Icons.logout, color: Colors.black),
            SizedBox(width: 8),
            Text("Konfirmasi Logout", style: TextStyle(color: Colors.black)),
          ],
        ),
        content: const Text(
          "Apakah Anda yakin ingin keluar?",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey[200],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Get.back(),
            child: const Text("Batal", style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey[200],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              exit(0); // keluar dari aplikasi
            },
            child: const Text("Iya", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
