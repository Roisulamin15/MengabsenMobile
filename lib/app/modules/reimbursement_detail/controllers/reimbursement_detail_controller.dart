import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ReimbursementDetailController extends GetxController {
  // FORM STATE (Dari Controller 1)
  final nama = ''.obs;
  final nomor = ''.obs;
  final tanggal = ''.obs;
  final bank = ''.obs;

  // DETAIL ITEMS (Dari Controller 2)
  final items = <Map<String, dynamic>>[].obs;

  // Formatter Rupiah
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  // Tambahkan item detail ke list
  void addItem(Map<String, dynamic> item) {
    items.add(item);
  }

  // Total otomatis dihitung
  String get totalFormatted => formatter.format(computeTotal());

  num computeTotal() {
    return items.fold<num>(0, (sum, it) {
      final raw = it['amount'] ?? 0;
      if (raw is num) return sum + raw;
      if (raw is String) {
        final v = int.tryParse(raw.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        return sum + v;
      }
      return sum;
    });
  }

  // Ambil data dari form controller (Controller 1)
  void setFormData({
    required String namaLengkap,
    required String nomorPengembalian,
    required String tanggalPemakaian,
    required String bankAccount,
  }) {
    nama.value = namaLengkap;
    nomor.value = nomorPengembalian;
    tanggal.value = tanggalPemakaian;
    bank.value = bankAccount;
  }

  // Simpan sekaligus navigasi
  void submitData() {
    if (nama.isEmpty ||
        nomor.isEmpty ||
        tanggal.isEmpty ||
        bank.isEmpty ||
        items.isEmpty) {
      Get.snackbar(
        "Oops",
        "Lengkapi form dan tambahkan detail minimal 1 item",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final payload = {
      "nama": nama.value,
      "nomor": nomor.value,
      "tanggal": tanggal.value,
      "bank": bank.value,
      "items": items,
      "total": computeTotal(),
      "status": "Menunggu Persetujuan",
    };

    Get.toNamed('/reimbursement-detail', arguments: payload);
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      nama.value = args["nama"] ?? "";
      nomor.value = args["nomor"] ?? "";
      tanggal.value = args["tanggal"] ?? "";
      bank.value = args["bank"] ?? "";
      items.assignAll(
        List<Map<String, dynamic>>.from(args["items"] ?? []),
      );
    }
  }
}
