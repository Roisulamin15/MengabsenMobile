import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../lembur/controllers/lembur_controller.dart';

class LemburFormController extends GetxController {
  final box = GetStorage();

  final namaC = TextEditingController();
  final jabatanList = ['Staff', 'Supervisor', 'Manager'];
  final jenisHariList = ['Hari Kerja', 'Hari Libur'];

  var jabatan = ''.obs;
  var jenisHari = ''.obs;

  final jamMulaiC = TextEditingController();
  final jamSelesaiC = TextEditingController();
  final durasiC = TextEditingController();

  final deskripsiPekerjaanC = TextEditingController();
  final alasanLemburC = TextEditingController();
  final keteranganC = TextEditingController();

  // 🔹 Fungsi pilih waktu
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

  // 🔹 Hitung durasi otomatis
  void _calculateDuration() {
    if (jamMulaiC.text.isEmpty || jamSelesaiC.text.isEmpty) return;

    try {
      final start = _parseTime(jamMulaiC.text);
      final end = _parseTime(jamSelesaiC.text);
      Duration diff = end.difference(start);
      if (diff.isNegative) diff += const Duration(hours: 24);

      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;
      durasiC.text = "${hours} jam ${minutes} menit";
    } catch (_) {
      durasiC.text = "0 jam 0 menit";
    }
  }

  DateTime _parseTime(String timeStr) {
    final parts = timeStr.split(":");
    return DateTime(0, 0, 0, int.parse(parts[0]), int.parse(parts[1]));
  }

  bool validateForm() {
    return !(namaC.text.isEmpty ||
        jabatan.value.isEmpty ||
        jamMulaiC.text.isEmpty ||
        jamSelesaiC.text.isEmpty ||
        durasiC.text.isEmpty ||
        jenisHari.value.isEmpty ||
        deskripsiPekerjaanC.text.isEmpty ||
        alasanLemburC.text.isEmpty);
  }

  /// 🔹 Kirim data lembur ke controller utama & simpan permanen
  void submitLembur() {
    final lemburData = {
      'nama': namaC.text,
      'jabatan': jabatan.value,
      'tanggal':
          "${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}",
      'jamMulai': jamMulaiC.text,
      'jamSelesai': jamSelesaiC.text,
      'durasi': durasiC.text,
      'jenisHari': jenisHari.value,
      'deskripsiPekerjaan': deskripsiPekerjaanC.text,
      'alasanLembur': alasanLemburC.text,
      'keterangan': keteranganC.text,
      'status': 'Menunggu',
    };

    // 🔸 Simpan ke GetStorage (lokal)
    List lemburList = box.read('lemburList') ?? [];
    lemburList.add(lemburData);
    box.write('lemburList', lemburList);

    // 🔸 Tambahkan juga ke controller agar UI langsung update
    final lemburCtrl = Get.find<LemburController>();
    lemburCtrl.addLembur(lemburData);

    // 🔸 Tutup dialog + halaman form
    Get.back(); // tutup dialog
    Get.back(); // kembali ke halaman lembur
  }
}
