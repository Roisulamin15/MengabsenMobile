import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HrdCutiController extends GetxController {
  var cutiList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  // Simulasi ambil API
  void fetchData() {
    cutiList.value = [
      {
        "nama": "Taufik Nur Abadi",
        "status": "Belum Review",
        "tanggal": "19/05/2022",
        "jabatan": "Staff IT",
        "nik": "1234567890",
        "jenis": "Cuti",
        "alasan": "Acara Keluarga",
        "lampiran": "PengajuanCutiTaufik07082024.pdf",
      },
      {
        "nama": "Raditya Banu",
        "status": "DISETUJUI PIC",
        "tanggal": "19/05/2022",
        "jabatan": "Karyawan",
        "nik": "987654321",
        "jenis": "Izin",
        "alasan": "Urusan Pribadi",
        "lampiran": "PengajuanCutiRadit08082024.pdf",
      },
      {
        "nama": "Fredrik Oswald",
        "status": "DITOLAK PIC",
        "tanggal": "19/05/2022",
        "jabatan": "Staff",
        "nik": "5566778899",
        "jenis": "Sakit",
        "alasan": "Demam Tinggi",
        "lampiran": "PengajuanCutiFredrik09082024.pdf",
      },
    ];
  }

  void showKonfirmasi(BuildContext context, bool disetujui) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    "Konfirmasi Cuti",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Icon(
                disetujui ? Icons.check_circle : Icons.error,
                color: disetujui ? Colors.green : Colors.red,
                size: 60,
              ),
              const SizedBox(height: 10),
              Text(
                disetujui
                    ? "Permintaan cuti telah anda setujui\nNotifikasi ini akan dikirim kepada staff."
                    : "Permintaan cuti telah anda tolak karena terlalu banyak pengajuan.\nNotifikasi ini akan dikirim kepada staff.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
