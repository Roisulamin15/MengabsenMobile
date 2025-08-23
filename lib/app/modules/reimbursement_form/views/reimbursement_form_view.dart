import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reimbursement_form_controller.dart';

class ReimbursementFormView extends GetView<ReimbursementFormController> {
  const ReimbursementFormView({super.key});

  InputDecoration get _line =>
      const InputDecoration(border: UnderlineInputBorder(), isDense: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Pengajuan Reimbursement'), centerTitle: true),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Nama Lengkap'),
              TextField(controller: controller.namaC, decoration: _line),
              const SizedBox(height: 12),

              const Text('Nomor Pengembalian'),
              TextField(
                  controller: controller.nomorC,
                  decoration: _line.copyWith(
                      hintText: 'Contoh 2022/07/RE/001')),
              const SizedBox(height: 12),

              // ✅ PERBAIKAN DI SINI (Tanggal Pemakaian)
              const Text('Tanggal Pemakaian'),
              GestureDetector(
                onTap: () => controller.pickDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: controller.tanggalC,
                    readOnly: true,
                    decoration: _line.copyWith(
                      hintText: 'Pilih tanggal',
                      // Pakai suffix agar ukuran field sama dengan TextField lainnya
                      suffix: Icon(
                        Icons.calendar_today,
                        size: 18, // Ukuran ikon lebih kecil supaya pas
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              const Text('Bank Account'),
              TextField(
                  controller: controller.bankC,
                  decoration: _line.copyWith(hintText: 'BNI')),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 6),
              const Text('Detail Pengajuan',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),

              Obx(() {
                final items = controller.detailItems;
                if (items.isEmpty) {
                  return SizedBox(
                    height: 180,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.info_outline,
                              size: 56, color: Colors.black26),
                          SizedBox(height: 8),
                          Text('Buat Pengajuan',
                              style: TextStyle(color: Colors.black45))
                        ],
                      ),
                    ),
                  );
                }
                return Column(
                  children: [
                    ...items.map((e) => Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            title: Text(e['type']),
                            subtitle: Text(e['tujuan']),
                            trailing: Text('Rp ${e['amount']}'),
                          ),
                        )),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('Total: Rp ${controller.total}',
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    )
                  ],
                );
              }),
              const SizedBox(height: 80),
            ]),
          ),

          Positioned(
            right: 16,
            bottom: 90,
            child: FloatingActionButton.extended(
              heroTag: 'add-detail',
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFDF8546),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xFFDF8546)),
                borderRadius: BorderRadius.circular(14),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Detail'),
              onPressed: controller.goAddDetail,
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              minimum: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDF8546),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: controller.submit,
                  child: const Text('Kirim',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
