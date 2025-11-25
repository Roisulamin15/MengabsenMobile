import 'dart:async';
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

  Timer? autoRefreshTimer; // <<=========== AUTO REFRESH TIMER

  String? get token => GetStorage().read("token");

  @override
  void initState() {
    super.initState();

    final data = Get.arguments;

    if (data is Map) {
      final id = _extractId(data);

      if (id != null) {
        fetchDetail(id);

        // ============================================
        // AUTO REFRESH SETIAP 5 DETIK
        // ============================================
        autoRefreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
          fetchDetail(id);
        });

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

  @override
  void dispose() {
    autoRefreshTimer?.cancel(); // <<========== STOP TIMER SAAT KELUAR HALAMAN
    super.dispose();
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

        print("===== DETAIL SURAT DARI API =====");
        print(surat);
        print("==================================");

      });
    } catch (e) {
      // tidak snackbar terus menerus saat auto refresh
    }
  }

  // ===============================
  // WIDGET ITEM TERSTANDAR
  // ===============================
  Widget item(String title, Widget valueWidget) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          valueWidget,
        ],
      ),
    );
  }

  // ===============================
  // BADGE STATUS BERWARNA
  // ===============================
  Widget statusBadge(String status) {
    Color bg;
    switch (status.toLowerCase()) {
      case "disetujui":
      case "approve":
      case "approved":
        bg = Colors.green;
        break;
      case "ditolak":
      case "reject":
      case "rejected":
        bg = Colors.red;
        break;
      default:
        bg = Colors.orange; // pending
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

    final user = GetStorage().read("user") ?? {};

    print("===== USER STORAGE =====");
    print(user);
    print("=========================");


    final nama =
        surat!["karyawan"]?["nama_lengkap"] ??
        surat!["karyawan"]?["name"] ??
        surat!["nama"] ??
        surat!["nama_karyawan"] ??
        user["nama_lengkap"] ??
        user["name"] ??
        "-";


    final nik = surat!["karyawan"]?["nik"] ?? surat!["nik"] ?? "-";

    final tanggal = surat!["tanggal"] ?? surat!["tanggal_pengajuan"] ?? "-";

    final jam = surat!["jam_pertemuan"] ?? surat!["jam"] ?? "-";

    final bertemu = surat!["bertemu"] ?? surat!["bertemu_dengan"] ?? "-";

    final perusahaan = surat!["perusahaan"]?.toString() ?? "-";

    final bersama =
        surat!["bersama_dengan"] ??
        surat!["bersama"] ??
        "-";

    final tujuan =
        surat!["tugas"] ?? surat!["tujuan_kunjungan"] ?? "-";

    final detail =
        surat!["detail_kunjungan"] ?? surat!["detail"] ?? "-";

    final status =
        surat!["status"] ??
        surat!["status_pengajuan"] ??
        surat!["status_tugas"] ??
        "-";

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
            item("Nama Lengkap", Text(nama)),
            item("NIK", Text(nik)),
            item("Tanggal", Text(tanggal)),
            item("Jam Pertemuan", Text(jam)),
            item("Bertemu Dengan", Text(bertemu)),
            item("Perusahaan / Instansi", Text(perusahaan)),
            item("Bersama Dengan", Text(bersama)),
            item("Tujuan Kegiatan", Text(tujuan)),
            item("Detail Kegiatan", Text(detail)),

            // STATUS BADGE
            item("Status", statusBadge(status.toString())),

            if (fileSurat != null) ...[
              item("File Surat", Text(fileSurat.toString())),
            ],

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text("Kembali"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
