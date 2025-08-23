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
        locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Reimbursement'),
        centerTitle: true,
      ),
      body: Obx(() {
        final rawForm = (controller.data['form'] as Map?) ?? {};
        String field(String key) =>
            (rawForm[key] ?? controller.data[key] ?? '-').toString();

        final rawItems = (controller.data['items'] as List?) ?? [];
        final items = rawItems.map<Map<String, dynamic>>((e) {
          final m = (e as Map?) ?? {};
          final tujuan = (m['tujuan'] ?? '-').toString();
          final amtRaw = m['amount'] ?? m['biaya'] ?? 0;

          int amount = 0;
          if (amtRaw is num) amount = amtRaw.toInt();
          if (amtRaw is String) {
            amount = int.tryParse(amtRaw.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          }

          return {"tujuan": tujuan, "amount": amount};
        }).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Detail Pengajuan',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),

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
                      (controller.data['title'] ?? '-').toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    const SizedBox(height: 16),
                    _row('Nama Lengkap', field('nama')),
                    _row('Nomor Pengembalian', field('nomor')),
                    _row(
                        'Tanggal Pemakaian',
                        field('tanggal') == '-'
                            ? (controller.data['date'] ?? '-').toString()
                            : field('tanggal')),
                    _row('Bank Account', field('bank')),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    if (items.isEmpty)
                      const Text('Belum ada item.', style: TextStyle(fontSize: 13))
                    else
                      ...items.map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(e['tujuan'] ?? '-',
                                        style: const TextStyle(fontSize: 14))),
                                Text(formatter.format(e['amount'] ?? 0),
                                    style: const TextStyle(fontSize: 14)),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.file_download_outlined,
                                      size: 20),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          )),
                    const Divider(),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Total Keseluruhan',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                        Text(controller.totalFormatted,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 15)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
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

                    final total = controller.computeTotal();

                    final payload = {
                      "title": controller.data['title'] ?? '-',
                      "status": "Menunggu Persetujuan",
                      "date": (controller.data['form']?['tanggal'] ??
                              controller.data['date'] ??
                              '-')
                          .toString(),
                      "form": rawForm.cast<String, dynamic>(),
                      "items": rawItems.cast<Map>(),
                      "total": total,
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
                                  child: Text('Berhasil',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                              const SizedBox(height: 18),
                              const Icon(Icons.check_circle_rounded,
                                  size: 70, color: Colors.green),
                              const SizedBox(height: 8),
                              const Text('Pengajuan Berhasil Disimpan',
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 18),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFFDF8546)),
                                  onPressed: () {
                                    Get.back(); // tutup dialog
                                    Get.offAllNamed('/reimbursement');
                                  },
                                  child: const Text('OK',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      barrierDismissible: false,
                    );
                  },
                  child: const Text('Kirim',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
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
              width: 120,
              child:
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
          ],
        ),
      );
}
