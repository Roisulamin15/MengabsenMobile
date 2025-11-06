import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailCutiView extends StatelessWidget {
  const DetailCutiView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>? ?? {};

    final nama = data['karyawan']?['nama_lengkap'] ?? '-';
    final nik = data['karyawan']?['nik'] ?? '-';
    final status = data['status'] ?? 'Menunggu Persetujuan';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Pengajuan Cuti",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow("Nama Lengkap", nama),
            _buildInfoRow("NIK", nik),
            _buildInfoRow("Jabatan", data['jabatan'] ?? '-'),
            const SizedBox(height: 12),

            _buildInfoRow("Jenis Izin", data['jenis_izin'] ?? '-'),
            const SizedBox(height: 12),

            _statusChip(status),

            const SizedBox(height: 12),
            _buildInfoRow("Tanggal Pengajuan", data['tanggal_pengajuan'] ?? '-'),
            _buildInfoRow(
              "Tanggal Izin",
              "${data['tanggal_izin'] ?? '-'} s/d ${data['tanggal_selesai'] ?? '-'}",
            ),

            const SizedBox(height: 12),
            _buildInfoRow("Alasan", data['alasan'] ?? '-'),

            const SizedBox(height: 30),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case "disetujui":
        color = Colors.green;
        break;
      case "ditolak":
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }

    return Row(
      children: [
        const Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(status, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
