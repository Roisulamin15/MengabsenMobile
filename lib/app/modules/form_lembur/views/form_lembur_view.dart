import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/form_lembur_controller.dart';
import '../../detail_lembur/views/detail_lembur_view.dart';
import '../../detail_lembur/controllers/detail_lembur_controller.dart';

class LemburFormView extends GetView<LemburFormController> {
  const LemburFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LemburFormController());

    InputDecoration underlineDeco(String label, {Widget? suffix}) =>
        InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.orange, width: 2),
          ),
          suffixIcon: suffix,
        );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pengajuan Lembur'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: controller.namaC,
              decoration: underlineDeco('Nama'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: underlineDeco('Jabatan'),
              value: controller.jabatan.value.isEmpty
                  ? null
                  : controller.jabatan.value,
              items: controller.jabatanList
                  .map((j) => DropdownMenuItem(value: j, child: Text(j)))
                  .toList(),
              onChanged: (val) => controller.jabatan.value = val ?? '',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.jamMulaiC,
              readOnly: true,
              decoration: underlineDeco(
                'Jam Mulai',
                suffix: IconButton(
                  icon: const Icon(Icons.access_time, color: Colors.orange),
                  onPressed: () => controller.pickTime(context, true),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.jamSelesaiC,
              readOnly: true,
              decoration: underlineDeco(
                'Jam Selesai',
                suffix: IconButton(
                  icon: const Icon(Icons.access_time_filled,
                      color: Colors.orange),
                  onPressed: () => controller.pickTime(context, false),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.durasiC,
              readOnly: true,
              decoration: underlineDeco('Durasi (jam & menit)'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: underlineDeco('Jenis Hari'),
              value: controller.jenisHari.value.isEmpty
                  ? null
                  : controller.jenisHari.value,
              items: controller.jenisHariList
                  .map((j) => DropdownMenuItem(value: j, child: Text(j)))
                  .toList(),
              onChanged: (val) => controller.jenisHari.value = val ?? '',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.deskripsiPekerjaanC,
              maxLines: 2,
              decoration: underlineDeco('Deskripsi Pekerjaan'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.alasanLemburC,
              maxLines: 2,
              decoration: underlineDeco('Alasan Lembur'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.keteranganC,
              maxLines: 2,
              decoration: underlineDeco('Keterangan (Opsional)'),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final success = controller.validateForm();

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      titlePadding: EdgeInsets.zero,
                      title: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: success ? Colors.orange : Colors.redAccent,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                        ),
                        child: Text(
                          'Konfirmasi Lembur',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            success ? Icons.check_circle : Icons.error,
                            color:
                                success ? Colors.green : Colors.redAccent,
                            size: 60,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            success
                                ? "Pengajuan lembur berhasil dikirim ke HRD."
                                : "Gagal! Harap lengkapi semua field sebelum submit.",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: success
                                  ? Colors.orange
                                  : Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              if (success) {
                                controller.submitLembur(); // ✅ kirim ke DetailLemburView
                              } else {
                                Get.back(); // Tutup dialog
                              }
                            },
                            child: const Text(
                              'OK',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Kirim Pengajuan',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
