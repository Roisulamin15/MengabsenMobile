import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../hrd_detail_surat_tugas/views/hrd_detail_surat_tugas_view.dart';
import '../controllers/hrd_surat_tugas_controller.dart';

class HrdSuratTugasView extends GetView<HrdSuratTugasController> {
  const HrdSuratTugasView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "List Pengajuan Surat Tugas",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.suratList.isEmpty) {
          return const Center(child: Text("Belum ada pengajuan surat tugas."));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchData,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.suratList.length,
            itemBuilder: (context, index) {
              final surat = controller.suratList[index];

              print("DATA SURAT ITEM:");
              print(surat);


              final nama = surat['karyawan']?['nama_lengkap'] ?? "-";
              final nik  = surat['karyawan']?['nik'] ?? "-";


              final tanggal = surat['tanggal_pengajuan'] ?? "-";
              final tempat = surat['tempat_tugas'] ?? "-";

              final bertemu = surat['bertemu_dengan'] ?? "-"; 
              final perusahaan = surat['perusahaan'] ?? "-";
              final tujuan = surat['tujuan_kunjungan'] ?? "-";
              final detail = surat['detail_kunjungan'] ?? "-";

              final status = surat['status'] ?? "menunggu";


              return CustomSuratTugasCard(
                nama: nama,
                tanggal: tanggal,
                tempat: tempat,
                status: status,
                onTap: () {
                  Get.to(() => HrdDetailSuratTugasView(surat: surat));
                },
              );
            },
          ),
        );
      }),
    );
  }
}

class CustomSuratTugasCard extends StatelessWidget {
  final String nama;
  final String tanggal;
  final String tempat;
  final String status;
  final VoidCallback? onTap;

  const CustomSuratTugasCard({
    Key? key,
    required this.nama,
    required this.tanggal,
    required this.tempat,
    required this.status,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(status);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue.shade300,
              child: const Icon(Icons.assignment, color: Colors.white),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(tempat),
                const SizedBox(height: 4),
                Text(
                  tanggal,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Color _statusColor(String status) {
  switch (status.toLowerCase()) {
    case "disetujui":
      return Colors.green;
    case "ditolak":
      return Colors.red;
    default:
      return Colors.orange;
  }
}
