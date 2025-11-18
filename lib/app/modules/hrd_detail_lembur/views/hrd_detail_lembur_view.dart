import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../hrd_lembur/controllers/hrd_lembur_controller.dart';

class HrdDetailLemburView extends StatelessWidget {
  final Map<String, dynamic> lembur;

  const HrdDetailLemburView({super.key, required this.lembur});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HrdLemburController>();

    final nama = lembur['karyawan']?['nama_lengkap']
    ?? controller.karyawanMap[lembur['karyawan_id']]
    ?? '-';
    final jabatan = lembur['jabatan'] ?? '-';
    final tanggal = lembur['tanggal_lembur'] ?? lembur['tanggal'] ?? '-';
    final mulai = lembur['jam_mulai'] ?? '-';
    final selesai = lembur['jam_selesai'] ?? '-';
    final durasi = lembur['durasi']?.toString() ?? '-';
    final jenisHari = lembur['jenis_hari'] ?? '-';
    final deskripsi =
        lembur['deskripsi_pekerjaan'] ?? lembur['deskripsi'] ?? '-';
    final alasan = lembur['alasan_lembur'] ?? '-';
    final status = lembur['status'] ?? 'Menunggu';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Lembur"),
        centerTitle: true,
        backgroundColor: Colors.orange.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _row("Nama Lengkap", nama),
              _row("Jabatan", jabatan),
              _row("Tanggal", tanggal),
              _row("Jam Mulai", mulai),
              _row("Jam Selesai", selesai),
              _row("Durasi", "$durasi jam"),
              _row("Jenis Hari", jenisHari),
              _row("Deskripsi", deskripsi),
              _row("Alasan", alasan),
              const SizedBox(height: 30),

              if (status.toLowerCase() == "menunggu")
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showConfirmDialog(
                          context,
                          isApprove: false,
                          onConfirm: () async {
                            await controller.rejectLembur(lembur['id']);
                          },
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("Tolak", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showConfirmDialog(
                          context,
                          isApprove: true,
                          onConfirm: () async {
                            await controller.approveLembur(lembur['id']);
                          },
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("Setujui", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                )
              else
                Center(
                  child: Text(
                    "Status: $status",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  void _showConfirmDialog(BuildContext context,
      {required bool isApprove, required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Konfirmasi Lembur",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Icon(
                    isApprove ? Icons.check_circle : Icons.error_outline,
                    color: isApprove ? Colors.green : Colors.red,
                    size: 70,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isApprove
                        ? "Pengajuan lembur telah disetujui.\nNotifikasi akan dikirim ke staff."
                        : "Pengajuan lembur telah ditolak.\nNotifikasi akan dikirim ke staff.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14, color: Colors.black87, height: 1.4),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // tutup dialog
                      onConfirm(); // jalankan approve/reject
                      Get.offAllNamed('/hrd-lembur'); // kembali ke halaman HRD Lembur
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
