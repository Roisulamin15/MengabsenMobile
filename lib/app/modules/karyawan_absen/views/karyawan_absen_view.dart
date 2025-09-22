import 'package:flutter/material.dart';
import 'package:flutter_application_mengabsen/app/widgets/absen_lokasi_selector.dart';
import 'package:get/get.dart';
import '../controllers/karyawan_absen_controller.dart';
import 'absen_lokasi_selector.dart';

class KaryawanAbsenView extends GetView<KaryawanAbsenController> {
  const KaryawanAbsenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Absensi"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Tab Absen & Riwayat
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.orange[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text("Absen",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: const Center(
                        child: Text("Riwayat Absen",
                            style: TextStyle(color: Colors.black54)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              "Jangan sampe lupa isi absensi nya ya",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 🔹 Komponen lokasi absen reusable
            AbsenLokasiSelector(),
            const SizedBox(height: 12),

            // 🔹 Dropdown keterangan
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: Obx(
                  () => DropdownButton<String>(
                    value: controller.selectedKeterangan.value.isEmpty
                        ? null
                        : controller.selectedKeterangan.value,
                    hint: const Text("Pilih Keterangan"),
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                          value: "Sakit", child: Text("Sakit")),
                      DropdownMenuItem(
                          value: "Izin", child: Text("Izin")),
                      DropdownMenuItem(
                          value: "Cuti", child: Text("Cuti")),
                    ],
                    onChanged: (value) {
                      controller.selectedKeterangan.value = value!;
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 🔹 Deskripsi
            TextField(
              controller: controller.deskripsi,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Deskripsi",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Get.snackbar("Absen", "Data absen berhasil dikirim!",
                      snackPosition: SnackPosition.BOTTOM);
                },
                child: const Text("Submit",
                    style: TextStyle(color: Colors.white)),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Jam & Tanggal
            Obx(
              () => Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 20, color: Colors.black54),
                        const SizedBox(width: 8),
                        Text(
                          controller.waktu.value,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 20, color: Colors.black54),
                        const SizedBox(width: 8),
                        Text(
                          controller.tanggal.value,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
