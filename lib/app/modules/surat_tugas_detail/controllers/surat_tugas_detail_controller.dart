import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuratTugasDetailController extends GetxController {
  // Bisa dipakai kalau ada logika tambahan
  final count = 0.obs;
  void increment() => count.value++;
}

class SuratTugasDetailView extends GetView<SuratTugasDetailController> {
  const SuratTugasDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Surat Tugas"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  "Judul: ${data["judul"] ?? '-'}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  "Bertemu Dengan: ${data["bertemu"] ?? '-'}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Tanggal: ${data["tanggal"] ?? '-'}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Status: ${data["status"] ?? '-'}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Kembali"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
