import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/riwayat_absen_controller.dart';

class RiwayatAbsenView extends GetView<RiwayatAbsenController> {
  const RiwayatAbsenView({super.key});

  @override
  Widget build(BuildContext context) {
    final String? lastJenis = Get.arguments; // WFO/WFH/WFA

    return Scaffold(
      appBar: AppBar(
        title: const Text("Absensi"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // 🔸 Tab Absen / Riwayat
          Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // 🔹 Tab Absen
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (lastJenis == "WFO" || lastJenis == "WFH" || lastJenis == "WFA") {
                        Get.offNamed('/karyawan-absen-wfo-wfh', arguments: lastJenis);
                      } else {
                        Get.offNamed('/karyawan-absen');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Absen",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                // 🔹 Tab Riwayat aktif
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Riwayat",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🔸 Isi Riwayat
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.riwayatList.length,
              itemBuilder: (context, index) {
                final item = controller.riwayatList[index];
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['tanggal'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              "In: ${item['jamMasuk']} ",
                              style: TextStyle(
                                color: item['statusIn'] == "On Time"
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "(${item['statusIn']})",
                              style: TextStyle(
                                color: item['statusIn'] == "On Time"
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['lokasi'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              "Out: ${item['jamKeluar']} ",
                              style: TextStyle(
                                color: item['statusOut'] == "Sudah Absen"
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "(${item['statusOut']})",
                              style: TextStyle(
                                color: item['statusOut'] == "Sudah Absen"
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['durasi'],
                              style: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.snackbar("Detail", "Fitur belum aktif");
                              },
                              child: const Text("Lihat Detail"),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
