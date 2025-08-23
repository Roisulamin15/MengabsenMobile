import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reimbursement_detail_input_controller.dart';
import '../../../routes/app_pages.dart';

class ReimbursementDetailInputView
    extends GetView<ReimbursementDetailInputController> {
  const ReimbursementDetailInputView({super.key});

  @override
  Widget build(BuildContext context) {
    final ddDeco = InputDecoration(
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengajuan Reimbursement',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Form(
        key: controller.formKey,
        child: Obx(
          () => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header jenis pengajuan
                const Text(
                  'Jenis Pengajuan',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  'Penggantian ${controller.type}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                // List item reimbursement
                ListView.builder(
                  itemCount: controller.items.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = controller.items[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TUJUAN
                          Flexible(
                            flex: 3,
                            child: DropdownButtonFormField<String>(
                              decoration: ddDeco,
                              value: item.tujuan.value,
                              items: controller.tujuanOptions
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e,
                                          style:
                                              const TextStyle(fontSize: 12),
                                        ),
                                      ))
                                  .toList(),
                              validator: (v) =>
                                  v == null ? 'Pilih tujuan' : null,
                              onChanged: (v) => item.tujuan.value = v,
                            ),
                          ),
                          const SizedBox(width: 8),

                          // BIAYA
                          Flexible(
                            flex: 3,
                            child: TextFormField(
                              controller: item.biayaC,
                              keyboardType: TextInputType.number,
                              decoration: ddDeco.copyWith(
                                prefixText: 'Rp ',
                                prefixStyle: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: const TextStyle(fontSize: 12),
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'Wajib diisi'
                                      : null,
                            ),
                          ),
                          const SizedBox(width: 8),

                          // BUKTI
                          Flexible(
                            flex: 2,
                            child: Obx(
                              () => InkWell(
                                onTap: () => controller.toggleProof(index),
                                child: Container(
                                  height: 43,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      item.proofPicked.value
                                          ? 'Dipilih'
                                          : 'Tambah',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: item.proofPicked.value
                                            ? Colors.black
                                            : const Color(0xFFDF8546),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // Tombol tambah baris
                InkWell(
                  onTap: controller.addItem,
                  child: Row(
                    children: const [
                      Icon(Icons.add_circle_outline,
                          size: 20, color: Color(0xFFDF8546)),
                      SizedBox(width: 4),
                      Text(
                        'Tambah',
                        style: TextStyle(
                          color: Color(0xFFDF8546),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // TOTAL
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Keseluruhan',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Rp ${controller.formattedTotal}",
                      style: const TextStyle(
                        color: Color(0xFFDF8546),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),

      // Tombol simpan
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            height: 45,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDF8546),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (controller.formKey.currentState!.validate()) {
                  // siapkan data yang mau dikirim
                  final data = controller.items.map((e) {
                    return {
                      "tujuan": e.tujuan.value,
                      "biaya": e.biayaC.text,
                      "bukti": e.proofPicked.value,
                    };
                  }).toList();

                  // pindah halaman + bawa data
                  Get.offNamed(
                    Routes.REIMBURSEMENT_DETAIL,
                    arguments: {
                      "type": controller.type,
                      "items": data,
                      "total": controller.formattedTotal,
                    },
                  );
                }
              },
              child: const Text(
                'Simpan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
