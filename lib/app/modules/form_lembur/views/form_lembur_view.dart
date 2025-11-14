import 'package:flutter/material.dart';
import 'package:flutter_application_mengabsen/app/modules/form_lembur/controllers/form_lembur_controller.dart';
import 'package:get/get.dart';


class LemburFormView extends GetView<LemburFormController> {
  const LemburFormView({super.key});

  InputDecoration formDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
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
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LemburFormController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengajuan Lembur"),
        centerTitle: true,
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildLabel("Nama Lengkap"),
                  TextField(
                    controller: controller.namaC,
                    decoration: formDecoration(hint: "Masukkan nama lengkap"),
                  ),
                  const SizedBox(height: 12),

                  buildLabel("Jabatan"),
                  Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedJabatan.value.isEmpty
                            ? null
                            : controller.selectedJabatan.value,
                        items: controller.jabatanList
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) =>
                            controller.selectedJabatan.value = val ?? "",
                        decoration: formDecoration(),
                      )),
                  const SizedBox(height: 12),

                  buildLabel("Tanggal Lembur"),
                  Obx(() => TextFormField(
                        readOnly: true,
                        decoration: formDecoration(
                          hint:
                              "${controller.tanggalLembur.value.toLocal()}".split(' ')[0],
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today, size: 18),
                            onPressed: () => controller.pickTanggal(context),
                          ),
                        ),
                      )),
                  const SizedBox(height: 12),

                  buildLabel("Jam Mulai"),
                  TextFormField(
                    controller: controller.jamMulaiC,
                    readOnly: true,
                    decoration: formDecoration(hint: "Pilih jam mulai").copyWith(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.access_time, size: 18),
                        onPressed: () =>
                            controller.pickTime(context, true),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

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
                  const SizedBox(height: 12),

                  buildLabel("Durasi (jam)"),
                  TextField(
                    controller: controller.durasiC,
                    readOnly: true,
                    decoration: formDecoration(hint: "Otomatis terisi"),
                  ),
                  const SizedBox(height: 12),

                  buildLabel("Jenis Hari"),
                  Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedJenisHari.value.isEmpty
                            ? null
                            : controller.selectedJenisHari.value,
                        items: controller.jenisHariList
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) =>
                            controller.selectedJenisHari.value = val ?? "",
                        decoration: formDecoration(),
                      )),
                  const SizedBox(height: 12),

                  buildLabel("Deskripsi Pekerjaan"),
                  TextField(
                    controller: controller.deskripsiC,
                    maxLines: 2,
                    decoration:
                        formDecoration(hint: "Masukkan deskripsi pekerjaan"),
                  ),
                  const SizedBox(height: 12),

                  buildLabel("Alasan Lembur"),
                  TextField(
                    controller: controller.alasanC,
                    maxLines: 2,
                    decoration: formDecoration(hint: "Masukkan alasan lembur"),
                  ),
                  const SizedBox(height: 12),

                  buildLabel("Keterangan (opsional)"),
                  TextField(
                    controller: controller.keteranganC,
                    maxLines: 2,
                    decoration: formDecoration(hint: "Masukkan keterangan"),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          controller.submitLemburToServer(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Kirim Pengajuan",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  )
                ],
              ),
            )),
    );
  }
}
