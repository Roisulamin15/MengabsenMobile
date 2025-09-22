import 'package:flutter/material.dart';
import 'package:flutter_application_mengabsen/app/modules/karyawan_absen/controllers/karyawan_absen_controller.dart';
import 'package:flutter_application_mengabsen/app/routes/app_pages.dart';
import 'package:get/get.dart';
import '../controllers/karyawan_absen_controller.dart';
import '../../../routes/app_pages.dart'; // pastikan import sesuai struktur kamu

class AbsenLokasiSelector extends StatelessWidget {
  final KaryawanAbsenController controller = Get.find<KaryawanAbsenController>();

  AbsenLokasiSelector({super.key});

  void _handleSelection(String value) {
    controller.selectedOption.value = value;

    if (value == "WFO" || value == "WFH") {
      // pindah ke halaman WFO/WFH
      Get.toNamed(Routes.KARYAWAN_ABSEN_WFO_WFH, arguments: value);
    } else if (value == "Tidak Masuk Kerja") {
      // balik ke halaman KaryawanAbsen
      Get.toNamed(Routes.KARYAWAN_ABSEN);
    }
    // kalau WFA biarin di halaman sekarang
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Silahkan pilih lokasi absen"),
          Row(
            children: [
              Radio(
                value: "WFO",
                groupValue: controller.selectedOption.value,
                onChanged: (value) => _handleSelection(value!),
              ),
              const Text("WFO"),
              Radio(
                value: "WFH",
                groupValue: controller.selectedOption.value,
                onChanged: (value) => _handleSelection(value!),
              ),
              const Text("WFH"),
              Radio(
                value: "WFA",
                groupValue: controller.selectedOption.value,
                onChanged: (value) =>
                    controller.selectedOption.value = value!,
              ),
              const Text("WFA"),
            ],
          ),
          Row(
            children: [
              Radio(
                value: "Tidak Masuk Kerja",
                groupValue: controller.selectedOption.value,
                onChanged: (value) => _handleSelection(value!),
              ),
              const Text("Tidak Masuk Kerja"),
            ],
          ),
        ],
      ),
    );
  }
}
