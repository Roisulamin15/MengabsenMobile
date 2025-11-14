import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/detail_lembur_controller.dart';

class DetailLemburView extends GetView<DetailLemburController> {
  DetailLemburView({super.key});

  String _safe(dynamic v) {
    if (v == null || v.toString().isEmpty) return '-';
    return v.toString();
  }

  @override
  Widget build(BuildContext context) {
    final lembur = controller.lembur.value;
    final status = _safe(lembur['status']);

    Color statusColor;
    String statusText;

    switch (status.toLowerCase()) {
      case 'disetujui':
        statusColor = Colors.green;
        statusText = 'Disetujui';
        break;
      case 'ditolak':
        statusColor = Colors.red;
        statusText = 'Ditolak';
        break;
      default:
        statusColor = Colors.orange;
        statusText = 'Menunggu Persetujuan';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Pengajuan Lembur',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRow('Nama Lengkap', controller.namaUser.value),
                _buildRow('Jabatan', _safe(lembur['jabatan'])),
                _buildRow('Tanggal Lembur',
                    _safe(lembur['tanggal_lembur'] ?? lembur['tanggal'])),
                _buildRow('Jam Mulai', _safe(lembur['jam_mulai'])),
                _buildRow('Jam Selesai', _safe(lembur['jam_selesai'])),
                _buildRow('Durasi (Jam)', _safe(lembur['durasi'])),
                _buildRow('Jenis Hari', _safe(lembur['jenis_hari'])),
                _buildRow('Deskripsi Pekerjaan',
                    _safe(lembur['deskripsi_pekerjaan'] ?? lembur['deskripsi'])),
                _buildRow('Alasan Lembur', _safe(lembur['alasan_lembur'])),
                _buildRow('Keterangan', _safe(lembur['keterangan'])),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        statusText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Get.back(),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
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
