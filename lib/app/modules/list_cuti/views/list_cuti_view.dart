import 'package:flutter/material.dart';
import 'package:flutter_application_mengabsen/app/modules/cuti/views/cuti_view.dart';
import 'package:flutter_application_mengabsen/app/modules/detail_cuti/views/detail_cuti_view.dart';
import 'package:flutter_application_mengabsen/app/modules/list_cuti/controllers/list_cuti_controller.dart';
import 'package:get/get.dart';

class ListCutiView extends StatelessWidget {
  ListCutiView({super.key});

  final ListCutiController listController = Get.find<ListCutiController>();

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "disetujui":
        return Colors.green;
      case "ditolak":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cuti", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "List Cuti",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final data = listController.cutiList;
              if (data.isEmpty) {
                return const Center(
                  child: Text(
                    "Belum ada pengajuan cuti",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  String status = (item['status'] ?? 'Menunggu Persetujuan').toString();

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    child: ListTile(
                      onTap: () {
                        Get.to(
                          () => DetailCutiView(),arguments: item,
                        );
                      },
                      leading: const Icon(Icons.description, color: Colors.orange),
                      title: Text(
                        item['jenis_izin'] ?? '-',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            status,
                            style: TextStyle(
                              color: _getStatusColor(status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Tanggal: ${item['tanggal_pengajuan'] ?? '-'}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => Get.to(() => const CutiView()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                "Ajukan Cuti",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
