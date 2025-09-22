import 'package:flutter/material.dart';
import 'package:flutter_application_mengabsen/app/modules/hrd_detail_cuti/views/hrd_detail_cuti_view.dart';
import 'package:get/get.dart';
import '../controllers/hrd_cuti_controller.dart';


class HrdCutiView extends GetView<HrdCutiController> {
  const HrdCutiView({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.pinkAccent,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(cuti["nama"] ?? "-"),
                subtitle: Text("${cuti["jenis"]} - ${cuti["tanggal"]}"),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: cuti["status"] == "DISETUJUI PIC"
                        ? Colors.green.withOpacity(0.1)
                        : cuti["status"] == "DITOLAK PIC"
                            ? Colors.red.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    cuti["status"],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: cuti["status"] == "DISETUJUI PIC"
                          ? Colors.green
                          : cuti["status"] == "DITOLAK PIC"
                              ? Colors.red
                              : Colors.orange,
                    ),
                  ),
                ),
                onTap: () {
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
