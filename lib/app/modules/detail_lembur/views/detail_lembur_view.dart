import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/detail_lembur_controller.dart';

class DetailLemburView extends GetView<DetailLemburController> {
  const DetailLemburView({super.key});

  @override
  Widget build(BuildContext context) {
    final lembur = controller.lembur;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengajuan Lembur',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem("Nama Lengkap", lembur['nama'] ?? '-'),
            _buildDetailItem("Jabatan", lembur['jabatan'] ?? '-'),
            _buildDetailItem("Tanggal", lembur['tanggal'] ?? '-'),
            _buildDetailItem("Jam Mulai", lembur['jamMulai'] ?? '-'),
            _buildDetailItem("Jam Selesai", lembur['jamSelesai'] ?? '-'),
            _buildDetailItem("Durasi", lembur['durasi'] ?? '-'),
            _buildDetailItem("Jenis Hari", lembur['jenisHari'] ?? '-'),
            _buildDetailItem("Deskripsi Pekerjaan", lembur['deskripsiPekerjaan'] ?? '-'),
            _buildDetailItem("Alasan Lembur", lembur['alasanLembur'] ?? '-'),
            _buildDetailItem("Keterangan", lembur['keterangan'] ?? '-'),
            const SizedBox(height: 16),

            // 🔹 Status badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Status",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Menunggu Persetujuan",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // 🔸 Tombol OK
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.offAllNamed('/lembur'); // kembali ke halaman lembur
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
