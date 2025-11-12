import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../hrd_cuti/controllers/hrd_cuti_controller.dart';

class HrdDetailCutiView extends StatelessWidget {
  final Map<String, dynamic> cuti;
  const HrdDetailCutiView({super.key, required this.cuti});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HrdCutiController>();

    final nama = cuti['karyawan']?['nama_lengkap'] ?? '-';
    final nik = cuti['karyawan']?['nik'] ?? '-';
    final jabatan = cuti['karyawan']?['jabatan'] ?? cuti['jabatan'] ?? '-';
    final jenis = cuti['jenis_izin'] ?? '-';
    final tanggalPengajuan = cuti['tanggal_pengajuan'] ?? '-';
    final tanggalMulai = cuti['tanggal_izin'] ?? '-';
    final tanggalSelesai = cuti['tanggal_selesai'] ?? '-';
    final alasan = cuti['alasan'] ?? '-';
    final lampiran = cuti['lampiran'] ?? '-';
    final status = cuti['status'] ?? 'Menunggu';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Get.offAllNamed('/home'); // kembali ke halaman home
          },
        ),
        title: const Text(
          "Detail Pengajuan Cuti",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _textItem("Nama Lengkap", nama),
              _textItem("NIK", nik),
              _textItem("Jabatan", jabatan),
              _textItem("Jenis Izin", jenis),
              _textItem("Tanggal Pengajuan", tanggalPengajuan),
              _textItem("Tanggal Izin", "$tanggalMulai s/d $tanggalSelesai"),
              _textItem("Alasan", alasan),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Lampiran",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Text(lampiran, style: const TextStyle(color: Colors.grey)),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.download_outlined),
                        onPressed: () {
                          // TODO: implementasi download file
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              if (status.toLowerCase() == 'menunggu')
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showConfirmDialog(
                          context,
                          isApprove: false,
                          onConfirm: () async {
                            await controller.rejectCuti(cuti['id']);
                          },
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("Tolak", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showConfirmDialog(
                          context,
                          isApprove: true,
                          onConfirm: () async {
                            await controller.approveCuti(cuti['id']);
                          },
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child:
                            const Text("Setuju", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                )
              else
                Center(
                  child: Text(
                    "Status: $status",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  // ✅ Pop-up konfirmasi tampil langsung di tengah tanpa efek putih dari atas
  void _showConfirmDialog(BuildContext context,
      {required bool isApprove, required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      barrierDismissible: false, // tidak bisa ditutup di luar area dialog
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
                  // Header oranye
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Konfirmasi Cuti",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Icon
                  Icon(
                    isApprove ? Icons.check_circle : Icons.error_outline,
                    color: isApprove ? Colors.green : Colors.red,
                    size: 70,
                  ),
                  const SizedBox(height: 20),

                  // Pesan
                  Text(
                    isApprove
                        ? "Permintaan cuti telah anda setujui.\nNotifikasi ini akan dikirim kepada staff."
                        : "Permintaan cuti telah anda tolak karena terlalu banyak pengajuan.\nNotifikasi ini akan dikirim kepada staff.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14, color: Colors.black87, height: 1.4),
                  ),
                  const SizedBox(height: 30),

                  // Tombol OK
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop(); // tutup dialog
                      onConfirm(); // jalankan fungsi approve/reject
                      Get.offAllNamed('/hrd-cuti'); // kembali ke halaman HRD Cuti
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
