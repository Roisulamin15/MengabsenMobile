import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hrd_cuti_controller.dart';

class HrdCutiView extends StatelessWidget {
  const HrdCutiView({super.key});

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case "DISETUJUI":
        return Colors.green;
      case "DITOLAK":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HrdCutiController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Pengajuan Cuti"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.cutiList.isEmpty) {
          return const Center(child: Text("Belum ada pengajuan cuti."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.cutiList.length,
          itemBuilder: (context, index) {
            final cuti = controller.cutiList[index];
            final id = cuti['id'] ?? 0;
            final status = cuti['status'] ?? 'Menunggu';

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cuti['karyawan']?['nama'] ?? "Tanpa Nama",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text("${cuti['jabatan']} - ${cuti['jenis_izin']}"),
                    const SizedBox(height: 4),
                    Text("Tanggal: ${cuti['tanggal_izin']} s/d ${cuti['tanggal_selesai'] ?? '-'}"),
                    const SizedBox(height: 8),
                    Text("Alasan: ${cuti['alasan'] ?? '-'}"),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor(status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: _statusColor(status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (status == 'Menunggu') Row(
                          children: [
                            ElevatedButton(
                              onPressed: () =>
                                  controller.approveCuti(id, context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text("Approve",
                                  style: TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () =>
                                  controller.rejectCuti(id, context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text("Reject",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
