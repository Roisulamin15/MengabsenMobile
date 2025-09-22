import 'package:flutter/material.dart';
import 'package:flutter_application_mengabsen/app/modules/karyawan_absen/controllers/karyawan_absen_controller.dart';
import 'package:flutter_application_mengabsen/app/widgets/absen_lokasi_selector.dart';
import 'package:get/get.dart';
// widget selector lokasi
import '../../widgets/absen_lokasi_selector.dart';
// controller
import '../karyawan_absen/controllers/karyawan_absen_controller.dart';

class KaryawanAbsenWfoWfhView extends StatelessWidget {
  final String jenis; // WFO atau WFH
  const KaryawanAbsenWfoWfhView({super.key, required this.jenis});

  @override
  Widget build(BuildContext context) {
    final KaryawanAbsenController controller = Get.put(KaryawanAbsenController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Absensi"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Tab Absensi / Riwayat Absensi
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
                        child: Text("Absensi", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: const Center(
                        child: Text("Riwayat Absensi"),
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

            // 🔹 Panggil widget AbsenLokasiSelector (radio WFO/WFH/WFA/Tidak Masuk)
            AbsenLokasiSelector(),

            const SizedBox(height: 16),

            // 🔹 Dropdown Lokasi
            DropdownButtonFormField<String>(
              value: "Alamat Rumah",
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on, color: Colors.red),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(value: "Alamat Rumah", child: Text("Alamat Rumah")),
                DropdownMenuItem(value: "Kantor", child: Text("Kantor")),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),

            // 🔹 Map Placeholder
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Icon(Icons.map, size: 80, color: Colors.grey)),
            ),
            const SizedBox(height: 16),

            // 🔹 Foto Selfie
            const Text("Foto Selfie Anda"),
            const SizedBox(height: 8),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Icon(Icons.image, size: 50, color: Colors.grey)),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt),
              label: const Text("Ambil Foto Selfie"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(45),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

            // 🔹 Tombol Absen
            ElevatedButton(
              onPressed: () {
                debugPrint("Pilihan Lokasi: ${controller.selectedOption.value}");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(45),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Absen"),
            ),
            const SizedBox(height: 20),

            // 🔹 Info Jam & Tanggal
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.access_time, color: Colors.grey),
                  SizedBox(width: 8),
                  Text("12:24:00"),
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
                children: const [
                  Icon(Icons.calendar_today, color: Colors.grey),
                  SizedBox(width: 8),
                  Text("Kamis, 24 Jan 2023"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
