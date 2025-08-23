import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cuti_controller.dart';

class CutiView extends GetView<CutiController> {
  const CutiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengajuan Cuti"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nama Lengkap"),
            const SizedBox(height: 4),
            TextField(
              controller: controller.namaController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Masukkan nama lengkap",
              ),
            ),
            const SizedBox(height: 12),
            const Text("NIK"),
            const SizedBox(height: 4),
            TextField(
              controller: controller.nikController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Masukkan NIK",
              ),
            ),
            const SizedBox(height: 12),
            const Text("Jabatan"),
            const SizedBox(height: 4),
            Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedJabatan.value.isEmpty
                  ? null
                  : controller.selectedJabatan.value,
              items: controller.jabatanList
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => controller.selectedJabatan.value = val!,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            )),
            const SizedBox(height: 12),
            const Text("Jenis Izin"),
            const SizedBox(height: 4),
            Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedIzin.value.isEmpty
                  ? null
                  : controller.selectedIzin.value,
              items: controller.izinList
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => controller.selectedIzin.value = val!,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            )),
            const SizedBox(height: 12),
            const Text("Tanggal Pengajuan"),
            const SizedBox(height: 4),
            Obx(() => TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
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
                hintText:
                    "${controller.tanggalPengajuan.value.toLocal()}".split(' ')[0],
              ),
            )),
            const SizedBox(height: 12),
            const Text("Tanggal Izin"),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Obx(() => TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
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
                      hintText:
                          "${controller.tanggalMulai.value.toLocal()}".split(' ')[0],
                    ),
                  )),
                ),
                const SizedBox(width: 8),
                const Text("s/d"),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(() => TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
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
                      hintText:
                          "${controller.tanggalSelesai.value.toLocal()}".split(' ')[0],
                    ),
                  )),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text("Alasan (Opsional)"),
            const SizedBox(height: 4),
            TextField(
              controller: controller.alasanController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Boleh dikosongkan",
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload_file),
              label: const Text("Upload Lampiran (Opsional)"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.orange,
                side: const BorderSide(color: Colors.orange),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.ajukanCuti(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Kirim",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
