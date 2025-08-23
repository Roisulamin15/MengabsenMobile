import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailCutiView extends StatelessWidget {
  const DetailCutiView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil data cuti dari Get.arguments
    final Map<String, dynamic> data = Get.arguments ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pengajuan Cuti",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Informasi Karyawan ===
            _buildInfoRow("Nama Lengkap", data['nama'] ?? '-'),
            _buildInfoRow("NIK", data['nik'] ?? '-'),
            _buildInfoRow("Jabatan", data['jabatan'] ?? '-'),
            const SizedBox(height: 12),

            // === Jenis Izin ===
            _buildInfoRow("Jenis Izin", data['jenis'] ?? '-'),
            const SizedBox(height: 12),

            // === Status Cuti ===
            Row(
              children: [
                const Text(
                  "Status",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(data['status'] ?? "Menunggu Persetujuan"),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    data['status'] ?? "Menunggu Persetujuan",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            _buildInfoRow("Tanggal Pengajuan", data['tanggal_pengajuan'] ?? '-'),

            const SizedBox(height: 12),
            _buildInfoRow(
              "Tanggal Izin",
              "${data['tanggal_mulai'] ?? '-'}  s/d  ${data['tanggal_selesai'] ?? '-'}",
            ),

            const SizedBox(height: 12),
            _buildInfoRow("Alasan", data['alasan'] ?? '-'),

            const SizedBox(height: 12),

            // === Lampiran File ===
            if (data['lampiran'] != null && data['lampiran'] != '')
              _buildInfoRow("Lampiran", data['lampiran']),
            if (data['form_cuti'] != null && data['form_cuti'] != '')
              _buildInfoRow("Form Cuti", data['form_cuti']),

            const SizedBox(height: 30),

            // Tombol OK
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Get.back(),
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
          ],
        ),
      ),
    );
  }

  // Widget untuk membuat baris informasi
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Warna status
  Color _getStatusColor(String status) {
    switch (status) {
      case "Disetujui":
        return Colors.green;
      case "Ditolak":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
