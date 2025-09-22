import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cuti_controller.dart';

class CutiView extends GetView<CutiController> {
  const CutiView({super.key});

  // 🔹 Input Decoration simple & rapat
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengajuan Cuti"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Nama ===
            buildLabel("Nama Lengkap"),
            TextField(
              controller: controller.namaController,
              decoration: formDecoration(hint: "Masukkan nama lengkap"),
            ),
            const SizedBox(height: 12),

            // === NIK ===
            buildLabel("NIK"),
            TextField(
              controller: controller.nikController,
              keyboardType: TextInputType.number,
              decoration: formDecoration(hint: "Masukkan NIK"),
            ),
            const SizedBox(height: 12),

            // === Jabatan ===
            buildLabel("Jabatan"),
            Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedJabatan.value.isEmpty
                      ? null
                      : controller.selectedJabatan.value,
                  items: controller.jabatanList
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => controller.selectedJabatan.value = val!,
                  decoration: formDecoration(),
                )),
            const SizedBox(height: 12),

            // === Jenis Izin ===
            buildLabel("Jenis Izin"),
            Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedIzin.value.isEmpty
                      ? null
                      : controller.selectedIzin.value,
                  items: controller.izinList
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => controller.selectedIzin.value = val!,
                  decoration: formDecoration(),
                )),
            const SizedBox(height: 12),

            // === Tanggal Pengajuan ===
            buildLabel("Tanggal Pengajuan"),
            Obx(() => TextFormField(
                  readOnly: true,
                  decoration: formDecoration(
                    hint:
                        "${controller.tanggalPengajuan.value.toLocal()}".split(' ')[0],
                  ).copyWith(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today, size: 18),
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: controller.tanggalPengajuan.value,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          controller.tanggalPengajuan.value = picked;
                        }
                      },
                    ),
                  ),
                )),
            const SizedBox(height: 12),

            // === Tanggal Izin ===
            buildLabel("Tanggal Izin"),
            Row(
              children: [
                Expanded(
                  child: Obx(() => TextFormField(
                        readOnly: true,
                        decoration: formDecoration(
                          hint:
                              "${controller.tanggalMulai.value.toLocal()}".split(' ')[0],
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today, size: 18),
                            onPressed: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: controller.tanggalMulai.value,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                controller.tanggalMulai.value = picked;
                              }
                            },
                          ),
                        ),
                      )),
                ),
                const SizedBox(width: 6),
                const Text("s/d"),
                const SizedBox(width: 6),
                Expanded(
                  child: Obx(() => TextFormField(
                        readOnly: true,
                        decoration: formDecoration(
                          hint:
                              "${controller.tanggalSelesai.value.toLocal()}".split(' ')[0],
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today, size: 18),
                            onPressed: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: controller.tanggalSelesai.value,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                controller.tanggalSelesai.value = picked;
                              }
                            },
                          ),
                        ),
                      )),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // === Alasan ===
            buildLabel("Alasan"),
            TextField(
              controller: controller.alasanController,
              maxLines: 2,
              decoration: formDecoration(hint: "Masukkan alasan cuti"),
            ),
            const SizedBox(height: 14),

            // === Upload Lampiran ===
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload_file, size: 18),
              label: const Text("Upload Lampiran"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange,
                side: const BorderSide(color: Colors.orange),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
            ),
            const SizedBox(height: 16),

            // === Tombol Kirim ===
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.ajukanCuti(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "Kirim",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
