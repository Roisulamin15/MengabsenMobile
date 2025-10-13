import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/lembur_controller.dart';
import '../../form_lembur/controllers/form_lembur_controller.dart';
import '../../form_lembur/views/form_lembur_view.dart';
import '../../detail_lembur/controllers/detail_lembur_controller.dart';
import '../../detail_lembur/views/detail_lembur_view.dart';


class LemburView extends GetView<LemburController> {
  const LemburView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lembur',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              "List Lembur",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),

          // 🔹 Filter Dropdowns
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: controller.selectedStatus.value,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      border: OutlineInputBorder(),
                    ),
                    items: controller.statusList
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status, style: const TextStyle(fontSize: 13)),
                            ))
                        .toList(),
                    onChanged: (val) {
                      controller.selectedStatus.value = val!;
                    },
                    hint: const Text("Status", style: TextStyle(fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: controller.selectedMonth.value,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      border: OutlineInputBorder(),
                    ),
                    items: controller.monthList
                        .map((bulan) => DropdownMenuItem(
                              value: bulan,
                              child: Text(bulan, style: const TextStyle(fontSize: 13)),
                            ))
                        .toList(),
                    onChanged: (val) {
                      controller.selectedMonth.value = val!;
                    },
                    hint: const Text("Bulan", style: TextStyle(fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: controller.selectedYear.value,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      border: OutlineInputBorder(),
                    ),
                    items: controller.yearList
                        .map((tahun) => DropdownMenuItem(
                              value: tahun,
                              child: Text(tahun, style: const TextStyle(fontSize: 13)),
                            ))
                        .toList(),
                    onChanged: (val) {
                      controller.selectedYear.value = val!;
                    },
                    hint: const Text("Tahun", style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 Daftar lembur (compact)
          Expanded(
            child: Obx(() {
              if (controller.daftarLembur.isEmpty) {
                return const Center(
                  child: Text(
                    "Belum ada data lembur",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                itemCount: controller.daftarLembur.length,
                itemBuilder: (context, index) {
                  final lembur = controller.daftarLembur[index];
                  Color borderColor;
                  Color textColor;

                  switch (lembur['status']) {
                    case 'Disetujui':
                      borderColor = Colors.green;
                      textColor = Colors.green;
                      break;
                    case 'Menunggu':
                      borderColor = Colors.orange;
                      textColor = Colors.orange;
                      break;
                    default:
                      borderColor = Colors.red;
                      textColor = Colors.red;
                  }

                  return InkWell(
                    onTap: () {
                      Get.to(() => const DetailLemburView(),
                          binding: BindingsBuilder(() {
                        Get.put(DetailLemburController());
                      }), arguments: lembur);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Kiri
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lembur['keterangan'] ?? 'Lembur',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 15),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Text(
                                  lembur['status'],
                                  style: TextStyle(
                                      color: textColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),

                          // Kanan
                          Row(
                            children: [
                              Text(
                                lembur['tanggal'],
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.arrow_forward_ios,
                                  size: 14, color: Colors.grey),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),

      // 🔹 Tombol Ajukan
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => Get.to(
                () => const LemburFormView(),
                binding: BindingsBuilder(() {
                  Get.put(LemburFormController());
                }),
              ),
              child: const Text(
                "Ajukan",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
