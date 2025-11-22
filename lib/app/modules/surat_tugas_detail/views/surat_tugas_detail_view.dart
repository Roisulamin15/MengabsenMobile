import 'package:flutter/material.dart';
import 'package:flutter_application_mengabsen/services/api_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SuratTugasDetailView extends StatefulWidget {
  const SuratTugasDetailView({super.key});

  @override
  State<SuratTugasDetailView> createState() => _SuratTugasDetailViewState();
}

class _SuratTugasDetailViewState extends State<SuratTugasDetailView> {
  Map<String, dynamic>? surat;
  bool loading = true;

  String? get token => GetStorage().read("token");

  @override
  void initState() {
    super.initState();

    final data = Get.arguments;
    if (data is Map) {
      final id = _extractId(data);
      if (id != null) {
        fetchDetail(id);
      } else {
        surat = Map<String, dynamic>.from(data);
        loading = false;
        setState(() {});
      }
    } else {
      loading = false;
      setState(() {});
    }
  }

  int? _extractId(Map m) {
    final keys = ['id', 'id_surat', 'surat_tugas_id', 'id_pengajuan'];
    for (final k in keys) {
      if (m.containsKey(k) && m[k] != null) {
        try {
          return int.parse(m[k].toString());
        } catch (_) {
          if (m[k] is int) return m[k];
        }
      }
    }
    return null;
  }

  Future<void> fetchDetail(int id) async {
    if (token == null) {
      Get.snackbar("Error", "Token tidak ditemukan");
      return;
    }

    try {
      final data = await ApiService.getSuratTugasDetail(id, token!);

      setState(() {
        surat = Map<String, dynamic>.from(data ?? {});
        loading = false;
      });
    } catch (e) {
      loading = false;
      setState(() {});
      Get.snackbar("Error", "Gagal memuat detail: $e");
    }
  }

  Widget item(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value ?? "-", style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Detail Surat Tugas")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (surat == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Detail Surat Tugas")),
        body: const Center(child: Text("Data tidak ditemukan")),
      );
    }

    // Data aman
    final user = GetStorage().read("user") ?? {};

    final nama =
    surat!["karyawan"]?["name"] ??
    surat!["nama"] ??
    surat!["nama_karyawan"] ??
    user["name"] ??
    user["nama"] ??
    user["full_name"] ??
    user["username"] ??
    "-";
    final nik = surat!["karyawan"]?["nik"] ?? surat!["nik"] ?? "-";
    final tanggal = surat!["tanggal"] ?? surat!["tanggal_pengajuan"] ?? "-";
    final jam = surat!["jam_pertemuan"] ?? surat!["jam"] ?? "-";
    final bertemu = surat!["bertemu"] ?? surat!["bertemu_dengan"] ?? "-";
    final perusahaan = surat!["perusahaan"]?.toString() ?? "-";
    final bersama_dengan = 
    surat!["bersama_dengan"] ??
    surat!["bersama"] ??
    "-";
    final tujuan = surat!["tugas"] ?? surat!["tujuan_kunjungan"] ?? "-";
    final detail = surat!["detail_kunjungan"] ?? surat!["detail"] ?? "-";

    final fileSurat = surat!['file_surat'] ??
        surat!['file'] ??
        surat!['form_surat'] ??
        surat!['file_ttd'] ??
        surat!['file_ttd_url'];

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Surat Tugas")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item("Nama Lengkap", nama),
            item("NIK", nik),
            item("Tanggal", tanggal),
            item("Jam Pertemuan", jam),
            item("Bertemu Dengan", bertemu),
            item("Perusahaan / Instansi", perusahaan),
            item("Bersama Dengan", bersama_dengan),
            item("Tujuan Kegiatan", tujuan),
            item("Detail Kegiatan", detail),

            if (fileSurat != null) ...[
              const SizedBox(height: 10),
              const Text("File Surat",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.grey)),
              const SizedBox(height: 4),
              Text(fileSurat.toString(), overflow: TextOverflow.ellipsis),
            ],

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back),
                label: const Text("Kembali"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
