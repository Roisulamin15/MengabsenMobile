import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../surat_tugas/controllers/surat_tugas_controller.dart';
import 'package:flutter_application_mengabsen/app/modules/surat_tugas_detail/views/surat_tugas_detail_view.dart';
import '../../../routes/app_pages.dart';

class SuratTugasView extends GetView<SuratTugasController> {
  const SuratTugasView({super.key});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "selesai":
        return Colors.green;
      case "ditolak":
        return Colors.red;
      case "disetujui":
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case "selesai":
        return Colors.green.shade50;
      case "ditolak":
        return Colors.red.shade50;
      case "disetujui":
        return Colors.blue.shade50;
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
            onPressed: () => controller.fetchSuratTugas(),
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// TITLE LEFT ALIGN
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "List Surat Tugas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),

            /// FILTER
            Row(
              children: [
                Expanded(
                  child: Obx(
                        () => DropdownButton<String>(
                      value: controller.selectedStatus.value,
                      hint: const Text("Status"),
                      isExpanded: true,
                      items: controller.statusList
                          .map((e) => DropdownMenuItem(
                          value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        controller.selectedStatus.value = val;
                        controller.filterSuratTugas();
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(
                        () => DropdownButton<String>(
                      value: controller.selectedMonth.value,
                      hint: const Text("Bulan"),
                      isExpanded: true,
                      items: controller.monthList
                          .map((e) => DropdownMenuItem(
                          value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        controller.selectedMonth.value = val;
                        controller.filterSuratTugas();
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(
                        () => DropdownButton<String>(
                      value: controller.selectedYear.value,
                      hint: const Text("Tahun"),
                      isExpanded: true,
                      items: controller.yearList
                          .map((e) => DropdownMenuItem(
                          value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        controller.selectedYear.value = val;
                        controller.filterSuratTugas();
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// LIST SURAT TUGAS
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredSuratTugas.isEmpty) {
                  return const Center(
                    child: Text("Belum ada surat tugas"),
                  );
                }

                final list = controller.filteredSuratTugas;

                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, index) {
                    final surat = list[index];
                    final status = surat["status"] ?? "-";

                    return InkWell(
                      onTap: () {
                        Get.to(
                              () => const SuratTugasDetailView(),
                          arguments: surat
                          );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              /// LEFT SIDE (Title + Status)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      surat["judul"] ?? "-",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getStatusBgColor(status),
                                        borderRadius:
                                        BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        status,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: _getStatusColor(status),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// RIGHT SIDE (Date + Arrow)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    surat["tanggal"] ?? "-",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Icon(Icons.arrow_forward_ios, size: 16),
                                ],
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            const SizedBox(height: 14),

            /// BUTTON AJUKAN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.toNamed(Routes.SURAT_TUGAS_FORM),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
            )
          ],
        ),
      ),
    );
  }
}
