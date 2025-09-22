import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HrdDetailCutiController extends GetxController {
  // contoh data dummy cuti, bisa diganti ambil dari API/DB
  final cutiDetail = {
    "nama": "Budi Santoso",
    "nik": "123456",
    "jabatan": "Staff IT",
    "tanggal_mulai": "2025-09-20",
    "tanggal_selesai": "2025-09-25",
    "jumlah_hari": "5 Hari",
    "alasan": "Pulang kampung"
  }.obs;

  // controller untuk textfield (kalau mau edit)
  final alasanC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    alasanC.text = cutiDetail["alasan"] ?? "";
  }

  void updateAlasan() {
    cutiDetail["alasan"] = alasanC.text;
    update();
    Get.snackbar("Sukses", "Alasan cuti berhasil diperbarui");
  }

  @override
  void onClose() {
    alasanC.dispose();
    super.onClose();
  }
}
