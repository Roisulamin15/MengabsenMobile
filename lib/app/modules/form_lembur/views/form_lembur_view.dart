  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:get_storage/get_storage.dart';

  import '../controllers/form_lembur_controller.dart';

  class LemburFormView extends GetView<LemburFormController> {
    const LemburFormView({super.key});

    InputDecoration formDecoration({String? hint}) {
      return InputDecoration(
        hintText: hint,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.5),
        ),
      );
    }

    Widget buildLabel(String text) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      final box = GetStorage();
      final namaUser = box.read('nama_lengkap') ?? '-';

      return Scaffold(
        appBar: AppBar(
          title: const Text("Pengajuan Lembur"),
          centerTitle: true,
        ),
        body: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /* ================= NAMA ================= */
                      buildLabel("Nama Lengkap"),
                      TextFormField(
                        initialValue: namaUser,
                        readOnly: true,
                        decoration: formDecoration(),
                      ),
                      const SizedBox(height: 14),

                      /* ================= JABATAN ================= */
                      buildLabel("Jabatan"),
                      Obx(
                        () => DropdownButtonFormField<String>(
                          value: controller.selectedJabatan.value.isEmpty
                              ? null
                              : controller.selectedJabatan.value,
                          items: controller.jabatanList
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                          onChanged: (val) =>
                              controller.selectedJabatan.value = val ?? '',
                          decoration: formDecoration(hint: "Pilih jabatan"),
                        ),
                      ),
                      const SizedBox(height: 14),

                      /* ================= TANGGAL ================= */
                      buildLabel("Tanggal Lembur"),
                      Obx(
                        () => TextFormField(
                          readOnly: true,
                          decoration: formDecoration(
                            hint:
                                controller.tanggalLembur.value
                                    .toIso8601String()
                                    .split('T')
                                    .first,
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today, size: 18),
                              onPressed: () =>
                                  controller.pickTanggal(context),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      /* ================= JAM MULAI ================= */
                      buildLabel("Jam Mulai"),
                      TextFormField(
                        controller: controller.jamMulaiC,
                        readOnly: true,
                        decoration:
                            formDecoration(hint: "Pilih jam mulai").copyWith(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.access_time, size: 18),
                            onPressed: () =>
                                controller.pickTime(context, true),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      /* ================= JAM SELESAI ================= */
                      buildLabel("Jam Selesai"),
                      TextFormField(
                        controller: controller.jamSelesaiC,
                        readOnly: true,
                        decoration:
                            formDecoration(hint: "Pilih jam selesai").copyWith(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.access_time, size: 18),
                            onPressed: () =>
                                controller.pickTime(context, false),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      /* ================= DURASI ================= */
                      buildLabel("Durasi (jam)"),
                      TextFormField(
                        controller: controller.durasiC,
                        readOnly: true,
                        decoration:
                            formDecoration(hint: "Otomatis terisi"),
                      ),
                      const SizedBox(height: 14),

                      /* ================= JENIS HARI ================= */
                      buildLabel("Jenis Hari"),
                      Obx(
                        () => DropdownButtonFormField<String>(
                          value: controller.selectedJenisHari.value.isEmpty
                              ? null
                              : controller.selectedJenisHari.value,
                          items: controller.jenisHariList
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                          onChanged: (val) =>
                              controller.selectedJenisHari.value = val ?? '',
                          decoration:
                              formDecoration(hint: "Pilih jenis hari"),
                        ),
                      ),
                      const SizedBox(height: 14),

                      /* ================= DESKRIPSI ================= */
                      buildLabel("Deskripsi Pekerjaan"),
                      TextField(
                        controller: controller.deskripsiC,
                        maxLines: 3,
                        decoration: formDecoration(
                          hint: "Masukkan deskripsi pekerjaan",
                        ),
                      ),
                      const SizedBox(height: 14),

                      /* ================= ALASAN ================= */
                      buildLabel("Alasan Lembur"),
                      TextField(
                        controller: controller.alasanC,
                        maxLines: 3,
                        decoration:
                            formDecoration(hint: "Masukkan alasan lembur"),
                      ),
                      const SizedBox(height: 14),

                      /* ================= KETERANGAN ================= */
                      buildLabel("Keterangan (opsional)"),
                      TextField(
                        controller: controller.keteranganC,
                        maxLines: 2,
                        decoration:
                            formDecoration(hint: "Masukkan keterangan"),
                      ),
                      const SizedBox(height: 20),

                      /* ================= BUTTON ================= */
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              controller.submitLemburToServer(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            "Kirim Pengajuan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );
    }
  }
