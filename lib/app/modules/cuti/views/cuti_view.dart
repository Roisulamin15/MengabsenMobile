import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cuti_controller.dart';

class CutiView extends GetView<CutiController> {
  const CutiView({super.key});

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
    // ❌ JANGAN Get.put DI SINI
    // controller sudah otomatis tersedia dari GetView

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengajuan Cuti"),
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
                    controller: controller.namaController,
                    decoration: formDecoration(hint: "Masukkan nama lengkap"),
                  ),
                  const SizedBox(height: 12),

                  buildLabel("NIK"),
                  TextField(
                    controller: controller.nikController,
                    keyboardType: TextInputType.number,
                    decoration: formDecoration(hint: "Masukkan NIK"),
                  ),
                  const SizedBox(height: 12),

                  buildLabel("Jabatan"),
                  Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedJabatan.value.isEmpty
                            ? null
                            : controller.selectedJabatan.value,
                        items: controller.jabatanList
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (val) =>
                            controller.selectedJabatan.value = val ?? "",
                        decoration: formDecoration(),
                      )),
                  const SizedBox(height: 12),

                  buildLabel("Jenis Izin"),
                  Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedIzin.value.isEmpty
                            ? null
                            : controller.selectedIzin.value,
                        items: controller.izinList
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (val) =>
                            controller.selectedIzin.value = val ?? "",
                        decoration: formDecoration(),
                      )),
                  const SizedBox(height: 12),

                  buildLabel("Tanggal Pengajuan"),
                  Obx(() => TextFormField(
                        readOnly: true,
                        decoration: formDecoration(
                          hint:
                              "${controller.tanggalPengajuan.value.toLocal()}"
                                  .split(' ')[0],
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon:
                                const Icon(Icons.calendar_today, size: 18),
                            onPressed: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate:
                                    controller.tanggalPengajuan.value,
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

                  buildLabel("Tanggal Izin"),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() => TextFormField(
                              readOnly: true,
                              decoration: formDecoration(
                                hint:
                                    "${controller.tanggalMulai.value.toLocal()}"
                                        .split(' ')[0],
                              ).copyWith(
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today,
                                      size: 18),
                                  onPressed: () async {
                                    DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate:
                                          controller.tanggalMulai.value,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );
                                    if (picked != null) {
                                      controller.tanggalMulai.value =
                                          picked;
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
                                    "${controller.tanggalSelesai.value.toLocal()}"
                                        .split(' ')[0],
                              ).copyWith(
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today,
                                      size: 18),
                                  onPressed: () async {
                                    DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate:
                                          controller.tanggalSelesai.value,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );
                                    if (picked != null) {
                                      controller.tanggalSelesai.value =
                                          picked;
                                    }
                                  },
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  buildLabel("Alasan"),
                  TextField(
                    controller: controller.alasanController,
                    maxLines: 2,
                    decoration:
                        formDecoration(hint: "Masukkan alasan cuti"),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.kirimCutiKeServer(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Kirim",
                        style: TextStyle(
                            color: Colors.white, fontSize: 15),
                      ),
                    ),
                  )
                ],
              ),
            )),
    );
  }
}
