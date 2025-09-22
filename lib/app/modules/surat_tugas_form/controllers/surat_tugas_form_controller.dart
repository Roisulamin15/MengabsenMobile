import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../surat_tugas/controllers/surat_tugas_controller.dart';
import '../../surat_tugas_detail/views/surat_tugas_detail_view.dart';

class SuratTugasFormController extends GetxController {
  final namaC = TextEditingController();
  final nikC = TextEditingController();
  final tanggalC = TextEditingController();
  final jamC = TextEditingController();
  final bertemuC = TextEditingController();
  final perusahaanC = TextEditingController();
  final detailC = TextEditingController();
  final bersamaC = TextEditingController();

  var showBersama = false.obs;

  final formKey = GlobalKey<FormState>();

  Future<void> pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );
    if (date != null) {
      tanggalC.text = "${date.day} ${_bulan(date.month)} ${date.year}";
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      jamC.text = "${time.hour}:${time.minute.toString().padLeft(2, "0")}";
    }
  }

  String _bulan(int month) {
    const bulan = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];
    return bulan[month - 1];
  }

  void submitForm() {
    if (namaC.text.isEmpty || nikC.text.isEmpty || tanggalC.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Lengkapi semua field wajib!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // 🔹 Data lengkap
    final surat = {
      "judul": "Surat ${perusahaanC.text.isNotEmpty ? perusahaanC.text : "Tanpa Nama"}",
      "status": "Proses",
      "tanggal": tanggalC.text,
      "jam": jamC.text,
      "nama": namaC.text,
      "nik": nikC.text,
      "bertemu": bertemuC.text,
      "perusahaan": perusahaanC.text,
      "bersama": bersamaC.text,
      "tugas": "Menghadiri Undangan Rapat / Meeting dari Klien",
      "detail": detailC.text,
    };

    final tugasC = Get.find<SuratTugasController>();
    tugasC.tambahSurat(surat);

    // 🔹 Tampilkan dialog sukses
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFFF7A00),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: const Center(
                child: Text(
                  "Berhasil Diajukan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Permintaan berhasil diajukan\nSilahkan menunggu konfirmasi dari HRD.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                onPressed: () {
                  Get.back(); // Tutup dialog
                  Get.off(() =>  SuratTugasDetailView(),
                      arguments: surat); // 🔹 Langsung ke detail
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7A00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 12),
                ),
                child: const Text("Lihat Detail",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
