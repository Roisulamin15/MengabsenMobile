import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_mengabsen/app/modules/absensi/controllers/absensi_controller.dart';

class AbsenLokasiSelector extends StatelessWidget {
  final AbsensiController controller = Get.find<AbsensiController>();

  AbsenLokasiSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Pilih Lokasi Absen"),
        Row(
          children: [
            Radio(
              value: "WFO",
              groupValue: controller.selectedOption.value,
              onChanged: (v) => controller.selectedOption.value = v!,
            ),
            const Text("WFO"),
            Radio(
              value: "WFH",
              groupValue: controller.selectedOption.value,
              onChanged: (v) => controller.selectedOption.value = v!,
            ),
            const Text("WFH"),
            Radio(
              value: "WFA",
              groupValue: controller.selectedOption.value,
              onChanged: (v) => controller.selectedOption.value = v!,
            ),
            const Text("WFA"),
          ],
        ),
        Row(
          children: [
            Radio(
              value: "Tidak Masuk",
              groupValue: controller.selectedOption.value,
              onChanged: (v) => controller.selectedOption.value = v!,
            ),
            const Text("Tidak Masuk Kerja"),
          ],
        ),
      ],
    ));
  }
}
