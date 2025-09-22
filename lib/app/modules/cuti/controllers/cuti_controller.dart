import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CutiController extends GetxController {
  // Observables
  var selectedJabatan = "".obs;
  var selectedIzin = "".obs;
  var tanggalPengajuan = DateTime.now().obs;
  var tanggalMulai = DateTime.now().obs;
  var tanggalSelesai = DateTime.now().obs;

  // Controllers
  final namaController = TextEditingController();
  final nikController = TextEditingController();
  final alasanController = TextEditingController();

  // Data list
  var cutiList = <Map<String, dynamic>>[].obs;

  // Pilihan jabatan
  final List<String> jabatanList = [
    "Project Manager",
    "Head of Business Analyst",
    "Head of IT Development",
    "Head of IT Operation",
    "Head Admin & Finance",
    "Business Analyst",
    "Lead Backend and Middleware",
    "Lead of Mobile Developer",
    "Lead of UI/UX Designer",
    "Backend and Middleware Developer",
    "Mobile Developer",
    "UI/UX Designer",
    "QA and IT Support",
    "Project & Admin Assistant",
  ];

  // Pilihan izin
  final List<String> izinList = ["Sakit", "Izin", "Cuti"];

  // Format tanggal
  String formatTanggal(DateTime date) {
    return DateFormat("dd/MM/yyyy").format(date);
  }

  // Ajukan cuti
  void ajukanCuti(BuildContext context) {
    if (selectedIzin.value.isEmpty) {
      Get.snackbar(
        "Gagal",
        "Jenis izin harus dipilih",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (namaController.text.isEmpty || nikController.text.isEmpty) {
      Get.snackbar(
        "Gagal",
        "Nama dan NIK harus diisi",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Tambah data cuti
    cutiList.add({
      "nama": namaController.text,
      "nik": nikController.text,
      "jabatan": selectedJabatan.value,
      "jenis": selectedIzin.value,
      "status": "Menunggu Persetujuan",
      "tanggal_pengajuan": formatTanggal(tanggalPengajuan.value),
      "tanggal_mulai": formatTanggal(tanggalMulai.value),
      "tanggal_selesai": formatTanggal(tanggalSelesai.value),
      "alasan": alasanController.text.isEmpty ? "-" : alasanController.text,
      "lampiran": "",
      "form_cuti": "",
    });

    // Reset form
    selectedJabatan.value = "";
    selectedIzin.value = "";
    namaController.clear();
    nikController.clear();
    alasanController.clear();

    // Tampilkan dialog sukses
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    "Cuti Berhasil Diajukan",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 10),
              const Text(
                "Permintaan berhasil diajukan\nSilahkan menunggu konfirmasi dari HRD.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.back();
                },
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onClose() {
    namaController.dispose();
    nikController.dispose();
    alasanController.dispose();
    super.onClose();
  }
}
