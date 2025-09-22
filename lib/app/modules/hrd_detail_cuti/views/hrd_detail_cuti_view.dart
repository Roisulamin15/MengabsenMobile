import 'package:flutter/material.dart';
import 'package:flutter_application_mengabsen/app/modules/hrd_cuti/controllers/hrd_cuti_controller.dart';
import 'package:get/get.dart';


class HrdDetailCutiView extends StatelessWidget {
  final Map<String, dynamic> cuti;
  const HrdDetailCutiView({super.key, required this.cuti});

  Widget _buildDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label)),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : "-",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HrdCutiController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengajuan Cuti"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetail("Nama Lengkap", cuti["nama"]),
              _buildDetail("NIK", cuti["nik"]),
              _buildDetail("Jabatan", cuti["jabatan"]),
              _buildDetail("Jenis Izin", cuti["jenis"]),
              _buildDetail("Tanggal Izin", cuti["tanggal"]),
              _buildDetail("Alasan", cuti["alasan"]),
              _buildDetail("Lampiran", cuti["lampiran"]),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () =>
                          controller.showKonfirmasi(context, false),
                      child: const Text("Tolak"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () =>
                          controller.showKonfirmasi(context, true),
                      child: const Text("Setuju"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
