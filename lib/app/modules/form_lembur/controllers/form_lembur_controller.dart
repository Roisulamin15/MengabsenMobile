import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../lembur/controllers/lembur_controller.dart';
import '../../lembur/views/lembur_view.dart';

class LemburFormController extends GetxController {
  final box = GetStorage();

  final namaC = TextEditingController();
  final deskripsiC = TextEditingController();
  final alasanC = TextEditingController();
  final keteranganC = TextEditingController();
  final jamMulaiC = TextEditingController();
  final jamSelesaiC = TextEditingController();
  final durasiC = TextEditingController();

  final jabatanList = ['Staff', 'Supervisor', 'Manager'];
  final jenisHariList = ['Hari Kerja Biasa', 'Hari Libur/Akhir Pekan', 'Hari Libur Nasional'];
  var selectedJabatan = ''.obs;
  var selectedJenisHari = ''.obs;

  var tanggalLembur = DateTime.now().obs;
  var isLoading = false.obs;

  final String baseUrl = "https://iotanesia-edu.web.id/api/lembur";

  Future<void> pickTanggal(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tanggalLembur.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) tanggalLembur.value = picked;
  }

  Future<void> pickTime(BuildContext context, bool isStart) async {
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      final formatted = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
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
    try {
      final s = _parseTime(jamMulaiC.text);
      final e = _parseTime(jamSelesaiC.text);
      var diff = e.difference(s);
      if (diff.isNegative) diff += const Duration(hours: 24);
      final hours = diff.inMinutes / 60;
      durasiC.text = hours.toStringAsFixed(2);
    } catch (_) {
      durasiC.text = "0.00";
    }
  }

  DateTime _parseTime(String t) {
    final p = t.split(':');
    return DateTime(0, 0, 0, int.parse(p[0]), int.parse(p[1]));
  }

  bool validateForm() {
    return !(namaC.text.isEmpty ||
        selectedJabatan.value.isEmpty ||
        jamMulaiC.text.isEmpty ||
        jamSelesaiC.text.isEmpty ||
        durasiC.text.isEmpty ||
        selectedJenisHari.value.isEmpty ||
        deskripsiC.text.isEmpty ||
        alasanC.text.isEmpty);
  }

  Future<void> submitLemburToServer(BuildContext context) async {
    if (!validateForm()) {
      _showDialog('Gagal', 'Harap lengkapi semua field!', isSuccess: false);
      return;
    }

    isLoading.value = true;
    final token = box.read('token') ?? '';
    final rawId = box.read('karyawan_id');
    final int karyawanId = (rawId is int) ? rawId : int.tryParse(rawId?.toString() ?? '') ?? 0;

    if (karyawanId == 0) {
      isLoading.value = false;
      _showDialog('Gagal', 'karyawan_id tidak ditemukan. Silakan login ulang.', isSuccess: false);
      return;
    }

    final tanggalIso = tanggalLembur.value.toIso8601String().split('T').first;
    final normalizedDurasi = double.tryParse(durasiC.text.replaceAll(',', '.')) ?? 0.0;

    final body = {
      'karyawan_id': karyawanId,
      'jabatan': selectedJabatan.value,
      'tanggal_lembur': tanggalIso,
      'jam_mulai': jamMulaiC.text,
      'jam_selesai': jamSelesaiC.text,
      'durasi': normalizedDurasi,
      'jenis_hari': selectedJenisHari.value,
      'deskripsi_pekerjaan': deskripsiC.text,
      'alasan_lembur': alasanC.text,
      'keterangan': keteranganC.text,
    };

    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 201 || res.statusCode == 200) {
        final lemburController = Get.find<LemburController>();
        body['status'] = 'Menunggu';
        body['nama'] = box.read('nama_lengkap') ?? '-';
        lemburController.addLembur(body);

        _showDialog('Berhasil', 'Pengajuan lembur berhasil!', isSuccess: true);
        clearForm();
      } else {
        _showDialog('Gagal', data['message'] ?? 'Terjadi kesalahan', isSuccess: false);
      }
    } catch (e) {
      _showDialog('Gagal', 'Terjadi kesalahan: $e', isSuccess: false);
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    namaC.clear();
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

  void _showDialog(String title, String message, {bool isSuccess = true}) {
    Get.defaultDialog(
      title: title,
      middleText: message,
      textConfirm: 'OK',
      onConfirm: () => Get.back(),
      barrierDismissible: false,
    );
  }
}
