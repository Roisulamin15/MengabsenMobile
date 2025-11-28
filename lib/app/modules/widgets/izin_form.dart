import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_mengabsen/app/modules/absensi/controllers/absensi_controller.dart';

class IzinForm extends StatelessWidget {
  final AbsensiController controller = Get.find<AbsensiController>();

  IzinForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: controller.selectedKeterangan.value.isEmpty ? null : controller.selectedKeterangan.value,
          items: const [
            DropdownMenuItem(value: "Sakit", child: Text("Sakit")),
            DropdownMenuItem(value: "Izin", child: Text("Izin")),
            DropdownMenuItem(value: "Cuti", child: Text("Cuti")),
          ],
          onChanged: (v) => controller.selectedKeterangan.value = v!,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.deskripsi,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: "Deskripsi",
            border: OutlineInputBorder(),
          ),
        )
      ],
    );
  }
}
