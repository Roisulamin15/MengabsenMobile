import 'package:flutter/material.dart';
import 'package:flutter_application_mengabsen/app/modules/widgets/absen_lokasi_selector.dart';
import 'package:get/get.dart';
import '../controllers/karyawan_absen_controller.dart';

class KaryawanAbsenView extends GetView<KaryawanAbsenController> {
  const KaryawanAbsenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // 🔹 Header dengan rounded dan judul di tengah
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.only(
              top: 40, // biar turun dari status bar
              left: 12,
              right: 12,
              bottom: 16,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 🔙 Tombol back di kiri
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Get.back(),
                  ),
                ),
                // 🔹 Judul di tengah
                const Text(
                  "Absensi",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Body utama
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Tab Absen & Riwayat
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                "Absen",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Get.toNamed('/riwayat-absen'),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: Text(
                                  "Riwayat Absen",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Teks pengingat
                  const Text(
                    "Jangan sampe lupa isi absensi nya ya 👇",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  // 🔹 Komponen lokasi absen reusable
                  AbsenLokasiSelector(),
                  const SizedBox(height: 20),

                  // 🔹 Dropdown dengan ikon lokasi merah
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: Obx(
                        () => DropdownButton<String>(
                          value: controller.selectedKeterangan.value.isEmpty
                              ? null
                              : controller.selectedKeterangan.value,
                          hint: Row(
                            children: const [
                              Icon(Icons.location_on, color: Colors.red),
                              SizedBox(width: 8),
                              Text("Pilih Keterangan"),
                            ],
                          ),
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
                  const SizedBox(height: 16),

                  // 🔹 Deskripsi
                  TextField(
                    controller: controller.deskripsi,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Deskripsi",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Tombol Submit
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.snackbar("Absen", "Data absen berhasil dikirim!",
                          snackPosition: SnackPosition.BOTTOM);
                    },
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text("Submit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Jam & Tanggal
                  Obx(
                    () => Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                controller.waktu.value,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                controller.tanggal.value,
                                style: const TextStyle(fontSize: 16),
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
          ),
        ],
      ),
    );
  }
}
