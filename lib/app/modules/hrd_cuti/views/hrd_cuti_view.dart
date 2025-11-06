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
        title: const Text(
          "List Pengajuan Cuti",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.cutiList.isEmpty) {
          return const Center(child: Text("Belum ada pengajuan cuti."));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchData,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.cutiList.length,
            itemBuilder: (context, index) {
              final cuti = controller.cutiList[index];
              final nama = cuti['karyawan']?['nama_lengkap'] ?? '-';
              final jenis = cuti['jenis_izin'] ?? '-';
              final tanggal = cuti['tanggal_izin'] ?? '-';
              final status = cuti['status'] ?? 'Menunggu';
              final foto = cuti['karyawan']?['foto'] ?? '';

              return CustomCutiCard(
                nama: nama,
                jenis: jenis,
                status: status,
                tanggal: tanggal,
                foto: foto,
                onTap: () {
                  Get.to(() => HrdDetailCutiView(cuti: cuti));
                  // Aksi saat card ditekan (jika ada)
                },
              );
            },
          ),
        );
      }),
    );
  }
}

class CustomCutiCard extends StatelessWidget {
  final String nama;
  final String jenis;
  final String status;
  final String tanggal;
  final String foto;
  final VoidCallback? onTap;

  const CustomCutiCard({
    Key? key,
    required this.nama,
    required this.jenis,
    required this.status,
    required this.tanggal,
    required this.foto,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundImage: foto.isNotEmpty
                  ? NetworkImage(foto)
                  : const AssetImage("assets/avatar.png") as ImageProvider,
            ),
            const SizedBox(width: 12),

            // Nama dan Status di sebelah avatar
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
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

            // Jenis izin dan tanggal di pojok kanan bawah (dalam satu kolom vertikal)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  jenis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tanggal,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
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
    case "ditolak pic":
      return Colors.red;
    default:
      return Colors.orange;
  }
}
