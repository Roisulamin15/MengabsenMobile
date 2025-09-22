import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuratTugasDetailView extends StatelessWidget {
  const SuratTugasDetailView({super.key});

  Widget _buildDetailItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            (value != null && value.isNotEmpty) ? value : "-",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case "Selesai":
        return Colors.green;
      case "Ditolak":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? surat = Get.arguments;

    if (surat == null || surat.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Detail Surat Tugas"),
          centerTitle: true,
        ),
        body: const Center(
          child: Text(
            "Data surat tugas tidak ditemukan!",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Surat Tugas"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              surat["judul"] ?? "Surat Tugas",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                const Text(
                  "Status: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  surat["status"] ?? "-",
                  style: TextStyle(
                    color: _getStatusColor(surat["status"]),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // ✅ Semua detail ditampilkan langsung
            _buildDetailItem("Nama Lengkap", surat["nama"]),
            _buildDetailItem("NIK", surat["nik"]),
            _buildDetailItem("Tanggal", surat["tanggal"]),
            _buildDetailItem("Jam Berangkat", surat["jam"]),
            _buildDetailItem("Bertemu Dengan", surat["bertemu"]),
            _buildDetailItem("Perusahaan/Instansi", surat["perusahaan"]),
            _buildDetailItem("Bersama Dengan", surat["bersama"]),
            _buildDetailItem("Tugas Kegiatan", surat["tugas"]),
            _buildDetailItem("Detail Kegiatan", surat["detail"]),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back),
                label: const Text(
                  "Oke",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
