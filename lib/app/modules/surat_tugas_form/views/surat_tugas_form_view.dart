// lib/modules/surat_tugas_form/views/surat_tugas_form_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/surat_tugas_form_controller.dart';

class SuratTugasFormView extends GetView<SuratTugasFormController> {
  const SuratTugasFormView({super.key});

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      border: const UnderlineInputBorder(),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange, width: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengajuan Surat Tugas", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth > 600 ? 500 : constraints.maxWidth * 0.95;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Nama Lengkap"),
                    TextField(controller: controller.namaC, decoration: _inputDecoration("Isi Nama Lengkap")),
                    const SizedBox(height: 8),

                    const Text("NIK"),
                    TextField(controller: controller.nikC, keyboardType: TextInputType.number, decoration: _inputDecoration("Isi NIK")),
                    const SizedBox(height: 8),

                    const Text("Tanggal Pengajuan"),
                    TextField(
                      controller: controller.tanggalC,
                      readOnly: true,
                      decoration: _inputDecoration("YYYY-MM-DD").copyWith(suffixIcon: const Icon(Icons.calendar_today)),
                      onTap: () => controller.pickDate(context),
                    ),
                    const SizedBox(height: 8),

                    const Text("Jam Pertemuan"),
                    TextField(
                      controller: controller.jamC,
                      readOnly: true,
                      decoration: _inputDecoration("HH:MM").copyWith(suffixIcon: const Icon(Icons.access_time)),
                      onTap: () => controller.pickTime(context),
                    ),
                    const SizedBox(height: 8),

                    const Text("Bertemu Dengan *"),
                    TextField(controller: controller.bertemuC, decoration: _inputDecoration("Isi Nama Tamu")),
                    const SizedBox(height: 8),

                    const Text("Perusahaan/Instansi *"),
                    TextField(controller: controller.perusahaanC, decoration: _inputDecoration("Nama Perusahaan")),
                    const SizedBox(height: 8),

                    Obx(() {
                      return Column(
                        children: [
                          if (controller.showBersama.value) ...[
                            const Text("Bersama Dengan"),
                            TextField(controller: controller.bersamaC, decoration: _inputDecoration("Isi Nama yang Bersama")),
                            const SizedBox(height: 8),
                          ],
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () {
                                controller.showBersama.value = true;
                              },
                              icon: const Icon(Icons.add_circle, color: Colors.orange),
                              label: const Text("Tambah orang", style: TextStyle(color: Colors.orange)),
                            ),
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 8),
                    const Text("Tujuan"),
                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration("Pilih Tujuan"),
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: "Menghadiri Undangan Rapat / Meeting dari Klien", child: Text("Menghadiri Undangan Rapat / Meeting dari Klien")),
                        DropdownMenuItem(value: "Menghadiri Undangan Rapat / Meeting dari Partner Bisnis", child: Text("Menghadiri Undangan Rapat / Meeting dari Partner Bisnis")),
                        DropdownMenuItem(value: "Melaksanakan Kegiatan SIT/UAT", child: Text("Melaksanakan Kegiatan SIT/UAT")),
                        DropdownMenuItem(value: "Melaksanakan Kegiatan Development Aplikasi", child: Text("Melaksanakan Kegiatan Development Aplikasi")),
                      ],
                      onChanged: (val) {
                        // kamu bisa simpan nilai ini kalau mau
                      },
                    ),
                    const SizedBox(height: 8),

                    const Text("Detail Kunjungan *"),
                    TextField(controller: controller.detailC, maxLines: 3, decoration: _inputDecoration("Tulis detail kunjungan")),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: Obx(() {
                        return ElevatedButton(
                          onPressed: controller.isSubmitting.value ? null : () => controller.submitForm(),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(vertical: 14)),
                          child: controller.isSubmitting.value ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("Kirim", style: TextStyle(color: Colors.white)),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
