import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../lembur/controllers/lembur_controller.dart';

class LemburFormController extends GetxController {
  final box = GetStorage();

  final deskripsiC = TextEditingController();
  final alasanC = TextEditingController();
  final keteranganC = TextEditingController();
  final jamMulaiC = TextEditingController();
  final jamSelesaiC = TextEditingController();
  final durasiC = TextEditingController();

  final jabatanList = ['Staff', 'Supervisor', 'Manager'];
  final jenisHariList = [
    'Hari Kerja Biasa',
    'Hari Libur/Akhir Pekan',
    'Hari Libur Nasional'
  ];

  var selectedJabatan = ''.obs;
  var selectedJenisHari = ''.obs;
  var tanggalLembur = DateTime.now().obs;
  var isLoading = false.obs;

  final String baseUrl = "https://iotanesia-edu.web.id/cms/api/lembur";

  /* ================= DATE ================= */
  Future<void> pickTanggal(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggalLembur.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) tanggalLembur.value = picked;
  }

  /* ================= TIME ================= */
  Future<void> pickTime(BuildContext context, bool isStart) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      final formatted =
          "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

      if (isStart) {
        jamMulaiC.text = formatted;
      } else {
        jamSelesaiC.text = formatted;
      }

      _calculateDuration();
    }
  }

  void _calculateDuration() {
    if (jamMulaiC.text.isEmpty || jamSelesaiC.text.isEmpty) return;

    final start = _parseTime(jamMulaiC.text);
    final end = _parseTime(jamSelesaiC.text);

    var diff = end.difference(start);
    if (diff.isNegative) diff += const Duration(hours: 24);

    durasiC.text = (diff.inMinutes / 60).toStringAsFixed(2);
  }

  DateTime _parseTime(String time) {
    final p = time.split(':');
    return DateTime(0, 1, 1, int.parse(p[0]), int.parse(p[1]));
  }

  /* ================= VALIDATION ================= */
  bool validateForm() {
    return selectedJabatan.value.isNotEmpty &&
        jamMulaiC.text.isNotEmpty &&
        jamSelesaiC.text.isNotEmpty &&
        durasiC.text.isNotEmpty &&
        selectedJenisHari.value.isNotEmpty &&
        deskripsiC.text.isNotEmpty &&
        alasanC.text.isNotEmpty;
  }

  /* ================= SUBMIT ================= */
  Future<void> submitLemburToServer(BuildContext context) async {
    if (!validateForm()) {
      showResultDialog(
        success: false,
        title: "Lembur Gagal Diajukan",
        message:
            "Permintaan gagal diajukan karena data tidak lengkap.\nSilakan coba lagi.",
      );
      return;
    }

    isLoading.value = true;

    final token = box.read('token') ?? '';
    final karyawanId =
        int.tryParse(box.read('karyawan_id')?.toString() ?? '') ?? 0;

    if (karyawanId == 0) {
      isLoading.value = false;
      showResultDialog(
        success: false,
        title: "Session Berakhir",
        message: "Silakan login ulang.",
      );
      return;
    }

    final body = {
      'karyawan_id': karyawanId,
      'jabatan': selectedJabatan.value,
      'tanggal_lembur':
          tanggalLembur.value.toIso8601String().split('T').first,
      'jam_mulai': jamMulaiC.text,
      'jam_selesai': jamSelesaiC.text,
      'durasi': double.parse(durasiC.text),
      'jenis_hari': selectedJenisHari.value,
      'deskripsi_pekerjaan': deskripsiC.text,
      'alasan_lembur': alasanC.text,
      'keterangan': keteranganC.text,
    };

    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.find<LemburController>().addLembur(body);
        clearForm();

        showResultDialog(
          success: true,
          title: "Lembur Berhasil Diajukan",
          message:
              "Permintaan berhasil diajukan.\nSilakan menunggu konfirmasi dari HRD.",
        );
      } else {
        showResultDialog(
          success: false,
          title: "Lembur Gagal Diajukan",
          message: "Terjadi kesalahan pada server.",
        );
      }
    } catch (e) {
      showResultDialog(
        success: false,
        title: "Error",
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    deskripsiC.clear();
    alasanC.clear();
    keteranganC.clear();
    jamMulaiC.clear();
    jamSelesaiC.clear();
    durasiC.clear();
    selectedJabatan.value = '';
    selectedJenisHari.value = '';
    tanggalLembur.value = DateTime.now();
  }

  /* ================= CUSTOM POPUP (SESUAI GAMBAR) ================= */
  void showResultDialog({
  required bool success,
  required String title,
  required String message,
}) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /* HEADER */
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: const BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          /* ICON */
          CircleAvatar(
            radius: 38,
            backgroundColor: success ? Colors.green : Colors.red,
            child: Icon(
              success ? Icons.check : Icons.warning_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ),

          const SizedBox(height: 22),

          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: ElevatedButton(
              onPressed: () {
                Get.back(); // tutup dialog

                if (success) {
                  // ⬇⬇ PINDAH KE HALAMAN LEMBUR
                  Get.offNamed('/lembur');
                  // atau jika mau hapus semua halaman sebelumnya:
                  // Get.offAllNamed('/lembur');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    ),
    barrierDismissible: false,
  );
}

  @override
  void onClose() {
    deskripsiC.dispose();
    alasanC.dispose();
    keteranganC.dispose();
    jamMulaiC.dispose();
    jamSelesaiC.dispose();
    durasiC.dispose();
    super.onClose();
  }
}
