import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_application_mengabsen/services/api_service.dart';

class HrdCutiController extends GetxController {
  var cutiList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  /// 🔹 Ambil data cuti dari backend
  Future<void> fetchData() async {
    isLoading.value = true;
    final token = box.read('token') ?? '';

    try {
      final response = await ApiService.getOutdays(token);
      cutiList.value = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("❌ Gagal ambil data cuti: $e");
      Get.snackbar("Gagal", "Tidak bisa memuat data cuti",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Approve cuti
  Future<void> approveCuti(int id, BuildContext context) async {
    final token = box.read('token') ?? '';
    try {
      final response = await ApiService.approveCuti(id, token);
      await fetchData();

      showKonfirmasi(context, true);
      Get.snackbar("Berhasil", response['message'] ?? "Cuti disetujui",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      print("❌ Gagal approve: $e");
      Get.snackbar("Gagal", "Tidak dapat menyetujui cuti",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  /// 🔹 Reject cuti
  Future<void> rejectCuti(int id, BuildContext context) async {
    final token = box.read('token') ?? '';
    try {
      final response = await ApiService.rejectCuti(id, token);
      await fetchData();

      showKonfirmasi(context, false);
      Get.snackbar("Ditolak", response['message'] ?? "Cuti ditolak",
          backgroundColor: Colors.orange, colorText: Colors.white);
    } catch (e) {
      print("❌ Gagal reject: $e");
      Get.snackbar("Gagal", "Tidak dapat menolak cuti",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  /// 🔹 Dialog konfirmasi
  void showKonfirmasi(BuildContext context, bool disetujui) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    "Konfirmasi Cuti",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Icon(
                disetujui ? Icons.check_circle : Icons.cancel,
                color: disetujui ? Colors.green : Colors.red,
                size: 60,
              ),
              const SizedBox(height: 10),
              Text(
                disetujui
                    ? "Permintaan cuti telah disetujui."
                    : "Permintaan cuti ditolak.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
