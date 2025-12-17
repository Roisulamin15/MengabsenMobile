import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../cuti/views/cuti_view.dart';
import '../../detail_cuti/views/detail_cuti_view.dart';
import '../controllers/list_cuti_controller.dart';

class ListCutiView extends StatelessWidget {
  const ListCutiView({super.key});

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('setuju')) return Colors.green;
    if (s.contains('tolak')) return Colors.red;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ListCutiController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cuti",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              "List Cuti",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.cutiList.isEmpty) {
                return const Center(
                  child: Text(
                    "Belum ada pengajuan cuti",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.cutiList.length,
                itemBuilder: (context, index) {
                  final item =
                      controller.cutiList[index];

                  final status =
                      (item['status'] ?? 'Menunggu')
                          .toString();
                  final jenis =
                      (item['jenis_izin'] ?? 'Cuti')
                          .toString();
                  final tanggal =
                      (item['tanggal_pengajuan'] ?? '-')
                          .toString();

                  final color = _statusColor(status);

                  return InkWell(
                    onTap: () async {
                      await Get.to(
                        () => DetailCutiView(),
                        arguments: item,
                      );
                      controller.fetchCuti(); // refresh manual
                    },
                    child: Container(
                      margin:
                          const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                jenis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(
                                          6),
                                  border: Border.all(
                                      color: color),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                tanggal,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: Colors.grey,
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
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                await Get.to(() => const CutiView());
                controller.fetchCuti(); // refresh setelah submit
              },
              child: const Text(
                "Ajukan Cuti",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
