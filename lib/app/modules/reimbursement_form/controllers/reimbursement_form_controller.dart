import 'package:flutter/material.dart';
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
  void submit() async {
    // Validasi form utama
    if (namaC.text.isEmpty ||
        nomorC.text.isEmpty ||
        tanggalC.text.isEmpty ||
        bankC.text.isEmpty) {
      Get.snackbar(
        "Oops",
        "Lengkapi semua field terlebih dahulu",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validasi minimal ada 1 detail
    if (detailItems.isEmpty) {
      Get.snackbar(
        "Oops",
        "Tambahkan detail pengajuan minimal 1 item",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Simpan ke variabel observable
    namaLengkap.value = namaC.text;
    nomorPengembalian.value = nomorC.text;
    tanggalPemakaian.value = tanggalC.text;
    bankAccount.value = bankC.text;

    // Siapkan payload untuk disimpan dan dikirim ke halaman detail
    final payload = {
      "title": "Penggantian ${detailItems.first['type']}",
      "status": "Menunggu Persetujuan",
      "date": tanggalC.text,
      "form": {
        "nama": namaC.text,
        "nomor": nomorC.text,
        "tanggal": tanggalC.text,
        "bank": bankC.text,
      },
      "items": detailItems.toList(),
      "total": total,
    };

    // Kirim ke reimbursementController supaya data tersimpan
    final reimbursementController = Get.find<ReimbursementController>();
    reimbursementController.addFromForm(payload);

    // Tampilkan dialog sukses
    await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFDF8546),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Berhasil',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Icon(Icons.check_circle_rounded,
                  size: 70, color: Colors.green),
              const SizedBox(height: 8),
              const Text('Pengajuan Berhasil Disimpan',
                  textAlign: TextAlign.center),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDF8546)),
                  onPressed: () {
                    Get.back(); // Tutup dialog
                    Get.offAllNamed('/reimbursement');
                  },
                  child:
                      const Text('OK', style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
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
