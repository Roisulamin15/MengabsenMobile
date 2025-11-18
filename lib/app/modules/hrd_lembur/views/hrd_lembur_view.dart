import 'package:flutter/material.dart';
import 'package:flutter_application_mengabsen/app/modules/hrd_detail_lembur/views/hrd_detail_lembur_view.dart';
import 'package:get/get.dart';
import '../controllers/hrd_lembur_controller.dart';

class HrdLemburView extends GetView<HrdLemburController> {
  const HrdLemburView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "List Pengajuan Lembur",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.lemburList.isEmpty) {
          return const Center(child: Text("Belum ada pengajuan lembur."));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchData,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.lemburList.length,
            itemBuilder: (context, index) {
              final lembur = controller.lemburList[index];

              final nama = lembur['karyawan']?['nama_lengkap']
              ?? controller.karyawanMap[lembur['karyawan_id']]
              ?? '-';
              final tanggal =
                  lembur['tanggal_lembur'] ?? lembur['tanggal'] ?? '-';
              final durasi =
                  lembur['durasi']?.toString() ?? '-';
              final status =
                  lembur['status'] ?? 'Menunggu';

              return InkWell(
                onTap: () => Get.to(
                  () => HrdDetailLemburView(lembur: lembur),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time_filled, size: 36),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(nama,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            const SizedBox(height: 4),
                            Text("Durasi: $durasi Jam"),
                          ],
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(tanggal),
                          const SizedBox(height: 6),
                          _statusBadge(status),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _statusBadge(String status) {
    Color color;

    switch (status.toLowerCase()) {
      case "disetujui":
        color = Colors.green;
        break;
      case "ditolak":
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
