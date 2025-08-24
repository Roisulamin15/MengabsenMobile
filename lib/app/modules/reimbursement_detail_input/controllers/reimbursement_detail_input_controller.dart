import 'package:flutter/material.dart';
import 'package:flutter_application_mengabsen/app/modules/reimbursement_detail/controllers/reimbursement_detail_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class ReimbursementDetailInputController extends GetxController {
  final formKey = GlobalKey<FormState>();
  late String type;

  final tujuanOptions = ['Makan', 'Transportasi', 'Hotel', 'Lainnya'];
  final formatter = NumberFormat('#,###', 'id_ID');

  /// List dinamis untuk form
  final items = <ReimbursementItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    type = Get.arguments?["type"] ?? '';
    addItem(); // Awal selalu ada satu baris input
  }

  /// Tambah baris baru
  void addItem() {
    final item = ReimbursementItem(
      tujuan: Rxn<String>(),
      biayaC: TextEditingController(),
      proofPicked: false.obs,
    );

    // Listener format Rupiah
    item.biayaC.addListener(() {
      final raw = item.biayaC.text.replaceAll(RegExp(r'[^0-9]'), '');
      final value = int.tryParse(raw) ?? 0;
      final formatted = raw.isEmpty ? '' : formatter.format(value);

      // Jaga cursor tidak pindah ke awal
      final oldOffset = item.biayaC.selection.baseOffset;
      final offset = max(0, min(formatted.length, oldOffset));

      item.biayaC.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: offset),
      );

      items.refresh(); // supaya Obx update total
    });

    items.add(item);
  }

  /// Hapus baris tertentu
  void removeItem(int index) {
    if (items.length > 1) {
      items.removeAt(index);
    }
  }

  /// Toggle status bukti
  void toggleProof(int index) {
    items[index].proofPicked.value = !items[index].proofPicked.value;
  }

  /// Hitung total semua biaya
  String get formattedTotal {
    int total = 0;
    for (var item in items) {
      final raw = item.biayaC.text.replaceAll(RegExp(r'[^0-9]'), '');
      total += int.tryParse(raw) ?? 0;
    }
    return formatter.format(total);
  }

  /// Simpan data & navigasi ke detail
  void save() {
  if (formKey.currentState?.validate() == true) {
    final detailController = Get.find<ReimbursementDetailController>();

    for (var item in items) {
      final raw = item.biayaC.text.replaceAll(RegExp(r'[^0-9]'), '');
      detailController.addItem({
        "tujuan": item.tujuan.value ?? "-",
        "amount": int.tryParse(raw) ?? 0,
        "type": type,
      });
    }

    Get.back(); // Balik ke form utama
  } else {
    Get.snackbar("Gagal", "Harap isi semua data dengan benar",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white);
  }
}


  @override
  void onClose() {
    for (var item in items) {
      item.biayaC.dispose();
    }
    super.onClose();
  }
}

class ReimbursementItem {
  final Rxn<String> tujuan;
  final TextEditingController biayaC;
  final RxBool proofPicked;

  ReimbursementItem({
    required this.tujuan,
    required this.biayaC,
    required this.proofPicked,
  });
}
