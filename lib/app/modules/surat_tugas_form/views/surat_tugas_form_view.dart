import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/surat_tugas_form_controller.dart';

class SuratTugasFormView extends GetView<SuratTugasFormController> {
  const SuratTugasFormView({super.key});

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      border: const UnderlineInputBorder(),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.orange, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pengajuan Surat Tugas",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth =
              constraints.maxWidth > 600 ? 500 : constraints.maxWidth * 0.9;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama
                    const Text("Nama Lengkap"),
                    TextField(
                      controller: controller.namaC,
                      decoration: _inputDecoration("Isi Nama Lengkap"),
                    ),
                    const SizedBox(height: 8),

                    // NIK
                    const Text("NIK"),
                    TextField(
                      controller: controller.nikC,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration("Isi NIK"),
                    ),
                    const SizedBox(height: 8),

                    // Tanggal
                    const Text("Tanggal Pengajuan"),
                    TextField(
                      controller: controller.tanggalC,
                      readOnly: true,
                      decoration: _inputDecoration("Hari, tanggal/bulan/tahun")
                          .copyWith(suffixIcon: const Icon(Icons.calendar_today)),
                      onTap: () => controller.pickDate(context),
                    ),
                    const SizedBox(height: 8),

                    // Jam
                    const Text("Jam Pertemuan"),
                    TextField(
                      controller: controller.jamC,
                      readOnly: true,
                      decoration: _inputDecoration("Jam Pertemuan")
                          .copyWith(suffixIcon: const Icon(Icons.access_time)),
                      onTap: () => controller.pickTime(context),
                    ),
                    const SizedBox(height: 8),

                    // Bertemu Dengan
                    const Text("Bertemu Dengan *"),
                    TextField(
                      controller: controller.bertemuC,
                      decoration: _inputDecoration("Isi Nama Tamu"),
                    ),
                    const SizedBox(height: 8),

                    // Perusahaan
                    const Text("Perusahaan/Instansi *"),
                    TextField(
                      controller: controller.perusahaanC,
                      decoration: _inputDecoration("Nama Perusahaan"),
                    ),
                    const SizedBox(height: 8),

                    // Bersama Dengan (opsional)
                    Obx(() {
                      return Column(
                        children: [
                          if (controller.showBersama.value) ...[
                            const Text("Bersama Dengan"),
                            TextField(
                              controller: controller.bersamaC,
                              decoration:
                                  _inputDecoration("Isi Nama yang Bersama"),
                            ),
                            const SizedBox(height: 8),
                          ],
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () {
                                controller.showBersama.value = true;
                              },
                              icon: const Icon(Icons.add_circle,
                                  color: Colors.orange),
                              label: const Text(
                                "Tambah orang",
                                style: TextStyle(color: Colors.orange),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 8),

                    // Tujuan
                    const Text("Tujuan"),
                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration("Pilih Tujuan"),
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                            value: "Mengirim Dokumen",
                            child: Text("Mengirim Dokumen")),
                        DropdownMenuItem(
                            value: "Mengambil Dokumen",
                            child: Text("Mengambil Dokumen")),
                        DropdownMenuItem(
                            value: "Mengirimkan Dokumen dengan Surat Kuasa",
                            child: Text("Mengirimkan Dokumen dengan Surat Kuasa")),
                        DropdownMenuItem(
                            value: "Mengambil Dokumen dengan Surat Kuasa",
                            child: Text("Mengambil Dokumen dengan Surat Kuasa")),
                        DropdownMenuItem(
                            value: "Menghadiri Undangan Rapat / Meeting dari Klien",
                            child: Text("Menghadiri Undangan Rapat / Meeting dari Klien")),
                        DropdownMenuItem(
                            value: "Menghadiri Undangan Rapat / Meeting dari Partner Bisnis",
                            child: Text("Menghadiri Undangan Rapat / Meeting dari Partner Bisnis")),
                        DropdownMenuItem(
                            value: "Melaksanakan Kegiatan SIT/UAT",
                            child: Text("Melaksanakan Kegiatan SIT/UAT")),
                        DropdownMenuItem(
                            value: "Melaksanakan Kegiatan Development Aplikasi",
                            child: Text("Melaksanakan Kegiatan Development Aplikasi")),
                        DropdownMenuItem(
                            value: "Menghadiri Konsultasi dengan Klien",
                            child: Text("Menghadiri Konsultasi dengan Klien")),
                        DropdownMenuItem(
                            value: "Menghadiri Konsultasi dengan Partner Bisnis",
                            child: Text("Menghadiri Konsultasi dengan Partner Bisnis")),
                        DropdownMenuItem(
                            value: "Melaksanakan Kegiatan dalam Pemenuhan Legalitas Perusahaan",
                            child: Text("Melaksanakan Kegiatan dalam Pemenuhan Legalitas Perusahaan")),
                        DropdownMenuItem(
                            value: "Melaksanakan Kegiatan dalam Pemenuhan Keuangan dan Perpajakan Perusahaan",
                            child: Text("Melaksanakan Kegiatan dalam Pemenuhan Keuangan dan Perpajakan Perusahaan")),
                      ],
                      onChanged: (val) {},
                    ),
                    const SizedBox(height: 8),

                    // Detail
                    const Text("Detail Kunjungan *"),
                    TextField(
                      controller: controller.detailC,
                      maxLines: 3,
                      decoration: _inputDecoration("Tulis detail kunjungan"),
                    ),
                    const SizedBox(height: 20),

                    // Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.submitForm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Kirim",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
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
