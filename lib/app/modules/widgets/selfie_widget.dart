import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_mengabsen/app/modules/absensi/controllers/absensi_controller.dart';

class SelfieWidget extends StatelessWidget {
  final AbsensiController controller = Get.find<AbsensiController>();

  SelfieWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Foto Selfie Anda",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          // ==============================
          // MUNCUL HANYA JIKA SUDAH SELFIE
          // ==============================
          if (controller.selfiePath.value.isNotEmpty) ...[
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
                image: DecorationImage(
                  image: FileImage(
                    File(controller.selfiePath.value),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],

          // ==============================
          // TOMBOL AMBIL SELFIE
          // ==============================
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffE68540),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.camera_alt),
              label: Text(
                controller.selfiePath.value.isEmpty
                    ? "Ambil Foto Selfie"
                    : "Ulangi Selfie",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                controller.ambilSelfie();
              },
            ),
          ),
        ],
      );
    });
  }
}
