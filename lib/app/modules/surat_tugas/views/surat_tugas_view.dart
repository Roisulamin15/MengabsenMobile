import 'package:flutter/material.dart';
import 'package:flutter_application_mengabsen/app/modules/surat_tugas_detail/views/surat_tugas_detail_view.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/surat_tugas_controller.dart';

class SuratTugasView extends GetView<SuratTugasController> {
  const SuratTugasView({super.key});

  Color _getStatusColor(String status) {
    switch (status) {
      case "Selesai":
        return Colors.green;
      case "Ditolak":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case "Selesai":
        return Colors.green.shade50;
      case "Ditolak":
        return Colors.red.shade50;
      default:
        return Colors.orange.shade50;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Surat Tugas",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.resetFilter(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====== LIST TITLE ======
            const Text(
              "List Surat Tugas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // ====== FILTER ======
            Row(
              children: [
                Expanded(
                  child: Obx(() => DropdownButton<String>(
                        value: controller.selectedStatus.value,
                        hint: const Text("Status"),
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: controller.statusList
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) {
                          controller.selectedStatus.value = val;
                          controller.filterSuratTugas();
                        },
                      )),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(() => DropdownButton<String>(
                        value: controller.selectedMonth.value,
                        hint: const Text("Bulan"),
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: controller.monthList
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) {
                          controller.selectedMonth.value = val;
                          controller.filterSuratTugas();
                        },
                      )),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(() => DropdownButton<String>(
                        value: controller.selectedYear.value,
                        hint: const Text("Tahun"),
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: controller.yearList
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) {
                          controller.selectedYear.value = val;
                          controller.filterSuratTugas();
                        },
                      )),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ====== LIST SURAT ======
            Expanded(
              child: Obx(() {
                if (controller.filteredSuratTugas.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada surat tugas",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: controller.filteredSuratTugas.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final surat = controller.filteredSuratTugas[index];
                    final status = surat["status"] ?? "-";

                    return Card(
                      margin: EdgeInsets.zero,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side:
                            BorderSide(color: Colors.grey.shade300, width: 0.8),
                      ),
                      elevation: 3,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        title: Text(
                          surat["judul"] ?? "-",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusBgColor(status),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: _getStatusColor(status),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                surat["tanggal"] ?? "-",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        trailing:
                            const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Get.to(
                            () => const SuratTugasDetailView(),
                            arguments: surat, // kirim data
                          );
                        },
                      ),
                    );
                  },
                );
              }),
            ),

            const SizedBox(height: 16),

            // ====== BUTTON AJUKAN ======
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.SURAT_TUGAS_FORM);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Ajukan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
