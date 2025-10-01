import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hrd_cuti_controller.dart';
import '../../hrd_detail_cuti/views/hrd_detail_cuti_view.dart';

class HrdCutiView extends StatelessWidget {
  const HrdCutiView({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case "DISETUJUI PIC":
        return Colors.green;
      case "DITOLAK PIC":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    // inject controller supaya tidak error
    final controller = Get.put(HrdCutiController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cuti"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.cutiList.isEmpty) {
          return const Center(child: Text("Belum ada data cuti"));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.cutiList.length,
          itemBuilder: (context, index) {
            final cuti = controller.cutiList[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                leading: const CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(
                  cuti["nama"] ?? "-",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("${cuti["jenis"]} - ${cuti["tanggal"]}"),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(cuti["status"]).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    cuti["status"],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _statusColor(cuti["status"]),
                    ),
                  ),
                ),
                onTap: () {
                  // navigasi ke detail cuti
                  Get.to(() => HrdDetailCutiView(cuti: cuti));
                },
              ),
            );
          },
        );
      }),
    );
  }
}
