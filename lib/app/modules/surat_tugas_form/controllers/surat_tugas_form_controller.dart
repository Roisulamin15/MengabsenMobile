// lib/modules/surat_tugas_form/controllers/surat_tugas_form_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_mengabsen/app/modules/surat_tugas/views/surat_tugas_view.dart';
import 'package:flutter_application_mengabsen/services/api_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
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
  final isSubmitting = false.obs;

  final formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  File? pickedFile;

  // ======================================================
  // ✅ AMBIL NAMA & NIK DARI LOGIN (GetStorage)
  // ======================================================
  @override
  void onInit() {
    super.onInit();

    final storage = GetStorage();

    // Sesuai dengan code login kamu
    namaC.text = storage.read("nama_lengkap") ?? "";
    nikC.text = storage.read("nik") ?? "";

    print("✅ Surat Tugas Form");
    print("Nama  : ${namaC.text}");
    print("NIK   : ${nikC.text}");
  }
  // ======================================================

  Future<void> pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );
    if (date != null) {
      tanggalC.text =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      jamC.text =
          "${time.hour}:${time.minute.toString().padLeft(2, "0")}";
    }
  }

  Future<void> pickFile() async {
    final XFile? file =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file != null) {
      pickedFile = File(file.path);
      update();
    }
  }

  void clearAll() {
    // ❗ nama & nik sengaja TIDAK di-clear
    tanggalC.clear();
    jamC.clear();
    bertemuC.clear();
    perusahaanC.clear();
    detailC.clear();
    bersamaC.clear();
    pickedFile = null;
  }

  Future<void> submitForm() async {
    if (tanggalC.text.isEmpty ||
        jamC.text.isEmpty ||
        bertemuC.text.isEmpty ||
        perusahaanC.text.isEmpty ||
        detailC.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Lengkapi semua field wajib!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final token = GetStorage().read("token");
    if (token == null) {
      Get.snackbar("Error", "User tidak terautentikasi");
      return;
    }

    final payload = {
      "tanggal_pengajuan": tanggalC.text,
      "jam_pertemuan": jamC.text,
      "bertemu_dengan": bertemuC.text,
      "perusahaan": perusahaanC.text,
      "bersama_dengan": "[\"${bersamaC.text}\"]",
      "tujuan_kunjungan":
          "Menghadiri Undangan Rapat / Meeting dari Klien",
      "detail_kunjungan": detailC.text,
    };

    try {
      isSubmitting.value = true;
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final res =
          await ApiService.submitSuratTugasBaru(payload, token);

      Get.back();
      isSubmitting.value = false;

      if (res['status'] == true || res['status'] == 'success') {
        final tugasC = Get.find<SuratTugasController>();
        await tugasC.fetchSuratTugas();

        final id = res['data']?['id'];

        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF7A00),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: const Center(
                    child: Text(
                      "Berhasil Diajukan",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Icon(Icons.check_circle,
                    size: 80, color: Colors.green),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Permintaan berhasil diajukan\nSilahkan menunggu konfirmasi dari HRD.",
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      if (id != null) {
                        Get.off(() => const SuratTugasView(),
                            arguments: {"id": id});
                      } else {
                        Get.offAllNamed("/surat_tugas");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7A00),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
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

        clearAll();
      } else {
        Get.snackbar("Gagal",
            res['message']?.toString() ?? "Gagal mengajukan");
      }
    } catch (e) {
      isSubmitting.value = false;
      Get.back();
      Get.snackbar("Error", "Gagal mengajukan: $e");
    }
  }
}
