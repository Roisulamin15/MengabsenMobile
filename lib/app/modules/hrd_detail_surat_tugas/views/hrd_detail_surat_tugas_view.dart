import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../hrd_surat_tugas/controllers/hrd_surat_tugas_controller.dart';

class HrdDetailSuratTugasView extends StatelessWidget {
  final Map<String, dynamic> surat;

  const HrdDetailSuratTugasView({super.key, required this.surat});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HrdSuratTugasController>();

    final nama = surat['karyawan']?['nama_lengkap'] 
          ?? surat['nama'] 
          ?? surat['nama_karyawan'] 
          ?? "-";
    final nik = surat['karyawan']?['nik'] ?? "-";
    final tanggal = surat['tanggal_pengajuan'] 
             ?? surat['tanggal'] 
             ?? "-";
    final bertemu = surat['bertemu_dengan'] ?? "-";
    final perusahaan = surat['perusahaan'] ?? "-";
    final bersama = surat['bersama_dengan'] 
             ?? surat['bersama'] 
             ?? "-";
    final tujuan = surat['tujuan_kunjungan'] ?? "-";
    final detail = surat['detail_kunjungan'] ?? "-";
    final statusRaw = surat['status'] ?? "menunggu";

    final statusDisplay = _statusText(statusRaw);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Surat Tugas"),
        centerTitle: true,
        backgroundColor: Colors.orange.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            _row("Nama", nama),
            _row("NIK", nik),
            _row("Tanggal", tanggal),
            _row("Bertemu Dengan", bertemu),
            _row("Perusahaan", perusahaan),
            _row("Tujuan", tujuan),
            _row("Detail", detail),
            const SizedBox(height: 30),
            _statusBadge(statusDisplay),
            const SizedBox(height: 30),

            // Jika status masih menunggu → tampilkan tombol approve/reject
            if (statusRaw.toLowerCase().contains("menunggu"))
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        _showConfirmDialog(
                          context,
                          isApprove: false,
                          onConfirm: () async {
                            await controller.rejectSurat(surat['id']);
                            Get.back(); // tutup dialog
                            
                            await Future.delayed(const Duration(milliseconds: 150));

                            Get.back(); // kembali ke list
                          },
                        );
                      },
                      child: const Text("Tolak"),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () {
                        _showConfirmDialog(
                          context,
                          isApprove: true,
                          onConfirm: () async {
                            await controller.approveSurat(surat['id']);
                            Get.back(); // tutup dialog

                            await Future.delayed(const Duration(milliseconds: 150));

                            Get.back(); // kembali ke list
                          },
                        );
                      },
                      child: const Text("Setujui"),
                    ),
                  ),
                ],
              ),
          ],
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
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color c;
    switch (status.toLowerCase()) {
      case "disetujui":
        c = Colors.green;
        break;
      case "ditolak":
        c = Colors.red;
        break;
      default:
        c = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: c),
        borderRadius: BorderRadius.circular(8),
        color: c.withOpacity(0.2),
      ),
      child: Text(
        status,
        style: TextStyle(color: c, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _statusText(String raw) {
    raw = raw.toLowerCase();
    if (raw.contains("disetujui") || raw.contains("approve")) return "Disetujui";
    if (raw.contains("ditolak") || raw.contains("reject")) return "Ditolak";
    return "Menunggu";
  }

  // Popup dialog konfirmasi
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
                        "Konfirmasi Surat Tugas",
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
                        ? "Surat tugas telah disetujui.\nNotifikasi akan dikirim ke staff."
                        : "Surat tugas ditolak.\nNotifikasi akan dikirim ke staff.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14, color: Colors.black87, height: 1.4),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: onConfirm,
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
