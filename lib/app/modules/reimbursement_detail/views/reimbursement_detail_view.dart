import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/reimbursement_detail_controller.dart';
import '../../reimbursement/controllers/reimbursement_controller.dart';

class ReimbursementDetailView extends GetView<ReimbursementDetailController> {
  const ReimbursementDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Reimbursement'),
        centerTitle: true,
      ),
      body: Obx(() {
        final items = controller.items;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Detail Pengajuan',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            // CARD DETAIL FORM
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.nama.value,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _row('Nama Lengkap', controller.nama.value),
                    _row('Nomor Pengembalian', controller.nomor.value),
                    _row('Tanggal Pemakaian', controller.tanggal.value),
                    _row('Bank Account', controller.bank.value),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),

                    // LIST ITEM
                    if (items.isEmpty)
                      const Text('Belum ada item.',
                          style: TextStyle(fontSize: 13))
                    else
                      ...items.map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  e['tujuan'] ?? '-',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              Text(
                                formatter.format(e['amount'] ?? 0),
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(
                                  Icons.file_download_outlined,
                                  size: 20,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),

                    const Divider(),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Total Keseluruhan',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Text(
                          controller.totalFormatted,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // BUTTON KIRIM
            SafeArea(
              top: false,
              minimum: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDF8546),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final reimbursementController =
                        Get.find<ReimbursementController>();

                    final payload = {
                      "title": controller.nama.value,
                      "status": "Menunggu Persetujuan",
                      "date": controller.tanggal.value,
                      "form": {
                        "nama": controller.nama.value,
                        "nomor": controller.nomor.value,
                        "tanggal": controller.tanggal.value,
                        "bank": controller.bank.value,
                      },
                      "items": controller.items,
                      "total": controller.computeTotal(),
                    };

                    reimbursementController.addFromForm(payload);

                    Get.dialog(
                      Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDF8546),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Berhasil',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 70,
                                color: Colors.green,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Pengajuan Berhasil Disimpan',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFDF8546),
                                  ),
                                  onPressed: () {
                                    Get.back(); // tutup dialog
                                    Get.offAllNamed('/reimbursement');
                                  },
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      barrierDismissible: false,
                    );
                  },
                  child: const Text(
                    'Kirim',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 140,
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      );
}
