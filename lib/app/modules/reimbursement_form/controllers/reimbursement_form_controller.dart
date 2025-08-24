import 'package:flutter/material.dart';
import 'package:flutter_application_mengabsen/app/modules/reimbursement_detail/controllers/reimbursement_detail_controller.dart';
import 'package:get/get.dart';
import '../../reimbursement/controllers/reimbursement_controller.dart';

class ReimbursementFormController extends GetxController {
  // Controller untuk input form
  final namaC = TextEditingController();
  final nomorC = TextEditingController();
  final tanggalC = TextEditingController();
  final bankC = TextEditingController();

  // Observable untuk menyimpan data hasil input
  final namaLengkap = ''.obs;
  final nomorPengembalian = ''.obs;
  final tanggalPemakaian = ''.obs;
  final bankAccount = ''.obs;

  // List detail pengajuan
  final detailItems = <Map<String, dynamic>>[].obs;

  // Hitung total otomatis
  num get total =>
      detailItems.fold<num>(0, (p, e) => p + (e['amount'] as num? ?? 0));

  // Pilih tanggal
  void pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialDate: now,
    );
    if (picked != null) {
      tanggalC.text =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
    }
  }

  // Navigasi ke halaman tambah detail
  void goAddDetail() {
    Get.toNamed('/reimbursement-type');
  }

  // Menambahkan detail baru dari halaman lain
  void pushDetail(Map<String, dynamic> item) {
    detailItems.add(item);
  }

  // Submit data form + detail
  void submit() {
  if (namaC.text.isEmpty ||
      nomorC.text.isEmpty ||
      tanggalC.text.isEmpty ||
      bankC.text.isEmpty) {
    Get.snackbar("Oops", "Lengkapi semua field", backgroundColor: Colors.red, colorText: Colors.white);
    return;
  }

  if (detailItems.isEmpty) {
    Get.snackbar("Oops", "Tambahkan detail pengajuan minimal 1 item", backgroundColor: Colors.red, colorText: Colors.white);
    return;
  }

  final detailController = Get.find<ReimbursementDetailController>();
  detailController.setFormData(
    namaLengkap: namaC.text,
    nomorPengembalian: nomorC.text,
    tanggalPemakaian: tanggalC.text,
    bankAccount: bankC.text,
  );

  for (var item in detailItems) {
    detailController.addItem(item);
  }

  detailController.submitData();
}


  @override
  void onClose() {
    namaC.dispose();
    nomorC.dispose();
    tanggalC.dispose();
    bankC.dispose();
    super.onClose();
  }
}
