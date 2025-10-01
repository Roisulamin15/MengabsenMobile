import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../hrd_cuti/controllers/hrd_cuti_controller.dart';
import '../controllers/hrd_detail_cuti_controller.dart';

class HrdDetailCutiView extends StatelessWidget {
  final Map<String, dynamic> cuti;
  const HrdDetailCutiView({super.key, required this.cuti});

  Widget _buildDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
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
    final cutiController = Get.find<HrdCutiController>();
    final detailController = Get.put(HrdDetailCutiController());

    // Set data cuti ke controller detail
    detailController.setCutiDetail(cuti);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengajuan Cuti"),
        centerTitle: true,
      ),
      body: Obx(() {
        final data = detailController.cutiDetail;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetail("Nama Lengkap", data["nama"] ?? ""),
                _buildDetail("NIK", data["nik"] ?? ""),
                _buildDetail("Jabatan", data["jabatan"] ?? ""),
                _buildDetail("Jenis Izin", data["jenis"] ?? ""),
                _buildDetail("Tanggal Izin", data["tanggal"] ?? ""),
                _buildDetail("Alasan", data["alasan"] ?? ""),
                _buildDetail("Lampiran", data["lampiran"] ?? ""),
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
                            cutiController.showKonfirmasi(context, false),
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
                            cutiController.showKonfirmasi(context, true),
                        child: const Text("Setuju"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
