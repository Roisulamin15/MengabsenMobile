// surat_tugas_detail_view.dart
// FINAL VERSION — DOWNLOAD PDF TERSIMPAN + AUTOREFRESH + FIX ALL

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_mengabsen/services/api_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class SuratTugasDetailView extends StatefulWidget {
  const SuratTugasDetailView({super.key});

  @override
  State<SuratTugasDetailView> createState() => _SuratTugasDetailViewState();
}

class _SuratTugasDetailViewState extends State<SuratTugasDetailView> {
  Map<String, dynamic>? surat;
  bool loading = true;

  final TextEditingController jamSelesaiC = TextEditingController();
  File? fileBukti;

  bool isPicking = false;
  bool isSubmitting = false;

  Timer? autoRefreshTimer;
  int? currentId;

  String? get token => GetStorage().read('token');

  @override
  void initState() {
    super.initState();

    final data = Get.arguments;
    if (data is Map) {
      final id = _extractId(data);
      if (id != null) {
        currentId = id;
        fetchDetail(id);
        _startAutoRefresh(id);
      } else {
        surat = Map<String, dynamic>.from(data);
        _maybeFillJamFromSurat();
        loading = false;
      }
    } else {
      loading = false;
    }
  }

  void _startAutoRefresh(int id) {
    autoRefreshTimer?.cancel();
    autoRefreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!isPicking && !isSubmitting) fetchDetail(id);
    });
  }

  void _stopAutoRefresh() {
    autoRefreshTimer?.cancel();
    autoRefreshTimer = null;
  }

  @override
  void dispose() {
    autoRefreshTimer?.cancel();
    jamSelesaiC.dispose();
    super.dispose();
  }

  int? _extractId(Map m) {
    final keys = ['id', 'id_surat', 'surat_tugas_id', 'id_pengajuan'];
    for (final k in keys) {
      if (m.containsKey(k) && m[k] != null) {
        try {
          return int.parse(m[k].toString());
        } catch (_) {
          if (m[k] is int) return m[k] as int;
        }
      }
    }
    return null;
  }

  Future<void> fetchDetail(int id) async {
    try {
      final data = await ApiService.getSuratTugasDetail(id, token!);
      setState(() {
        surat = (data is Map) ? Map<String, dynamic>.from(data) : {};
        loading = false;
      });
      _maybeFillJamFromSurat();
    } catch (e) {
      print("Fetch detail error: $e");
      setState(() => loading = false);
    }
  }

  void _maybeFillJamFromSurat() {
    if (surat == null) return;

    dynamic raw = surat!['jam_selesai'];
    if (raw != null) {
      final s = raw.toString();
      if (s.isNotEmpty && s != '-' && s != 'null') {
        final parts = s.split(':');
        if (parts.length >= 2) {
          jamSelesaiC.text =
              '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
        }
      }
    }
  }

  Future<void> pilihBukti() async {
    if (isPicking) return;
    isPicking = true;

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 80,
      );

      if (picked != null) {
        _stopAutoRefresh();

        setState(() {
          fileBukti = File(picked.path);
        });
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memilih gambar: $e");
    } finally {
      isPicking = false;
    }
  }

  Future<void> submitComplete(int id) async {
    if (jamSelesaiC.text.isEmpty) {
      Get.snackbar("Error", "Jam selesai wajib diisi");
      return;
    }
    if (fileBukti == null) {
      Get.snackbar("Error", "Upload bukti wajib (gambar)");
      return;
    }
    if (isSubmitting) return;

    isSubmitting = true;
    setState(() {});

    try {
      final url = '${ApiService.baseUrl}/surat_tugas/$id/complete';

      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json'
        ..fields['jam_selesai'] = '${jamSelesaiC.text}:00';

      final ext = fileBukti!.path.split('.').last;
      final filename =
          "bukti_${DateTime.now().millisecondsSinceEpoch}.$ext";

      request.files.add(await http.MultipartFile.fromPath(
        'file_ttd',
        fileBukti!.path,
        filename: filename,
      ));

      final streamed = await request.send();
      final body = await streamed.stream.bytesToString();

      if (streamed.statusCode == 200 || streamed.statusCode == 201) {
        Get.snackbar(
          "Berhasil",
          "Surat tugas diselesaikan",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        await fetchDetail(id);
        fileBukti = null;
        _startAutoRefresh(id);
      } else {
        Get.snackbar(
          "Gagal",
          body,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal mengirim: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting = false;
      setState(() {});
    }
  }

  /// =============================
  ///     DOWNLOAD & SAVE PDF
  /// =============================
  Future<void> downloadPDF(int id) async {
  try {
    final url = "${ApiService.baseUrl}/surat_tugas/$id/pdf";

    print("Requesting PDF: $url");

    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    );

    print("Status Code: ${response.statusCode}");
    print("Body: ${response.body}");

    if (response.statusCode != 200) {
      Get.snackbar(
        "Gagal",
        "Server belum menyediakan PDF. (${response.statusCode})",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final bytes = response.bodyBytes;
    final dir = await getApplicationDocumentsDirectory();
    final filePath = "${dir.path}/surat_tugas_$id.pdf";
    final file = File(filePath);

    await file.writeAsBytes(bytes);

    await OpenFile.open(filePath);

  } catch (e) {
    Get.snackbar(
      "Error",
      "Gagal download PDF: $e",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}


  Widget label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text(
          t,
          style: const TextStyle(
              fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      );

  Widget textItem(String t) =>
      Text(t, style: const TextStyle(fontSize: 15));

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (surat == null) {
      return const Scaffold(
        body: Center(child: Text("Data tidak ditemukan")),
      );
    }

    final id = surat!['id'];
    final status = surat!['status'] ?? '-';

    final nama = surat!['karyawan']?['nama_lengkap'] ?? '-';
    final nik = surat!['karyawan']?['nik'] ?? '-';
    final tanggal = surat!['tanggal_pengajuan'] ?? '-';
    final jamPertemuan = surat!['jam_pertemuan'] ?? '-';
    final bertemu = surat!['bertemu_dengan'] ?? '-';
    final perusahaan = surat!['perusahaan'] ?? '-';
    final bersama = surat!['bersama_dengan'] ?? '-';
    final tujuan = surat!['tujuan_kunjungan'] ?? '-';
    final detail = surat!['detail_kunjungan'] ?? '-';

    final jamTampil = jamSelesaiC.text.isNotEmpty
        ? jamSelesaiC.text
        : (surat!['jam_selesai']?.toString() ?? '-');

    return Scaffold(
      appBar: AppBar(title: const Text("Pengajuan Surat Tugas")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label("Nama Lengkap"),
            textItem(nama),
            const SizedBox(height: 12),

            label("NIK"),
            textItem(nik),
            const SizedBox(height: 12),

            label("Tanggal Pengajuan"),
            textItem(tanggal),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      label("Jam Pertemuan"),
                      textItem(jamPertemuan),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      label("Jam Selesai"),
                      status == "disetujui"
                          ? GestureDetector(
                              onTap: () async {
                                _stopAutoRefresh();
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (picked != null) {
                                  jamSelesaiC.text =
                                      "${picked.hour}:${picked.minute.toString().padLeft(2, '0')}";
                                  setState(() {});
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(jamTampil,
                                    style: const TextStyle(fontSize: 16)),
                              ),
                            )
                          : Text(jamTampil),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            label("Bertemu Dengan"),
            textItem(bertemu),
            const SizedBox(height: 12),

            label("Perusahaan / Instansi"),
            textItem(perusahaan),
            const SizedBox(height: 12),

            label("Bersama Dengan"),
            textItem(bersama),
            const SizedBox(height: 12),

            label("Tujuan Kegiatan"),
            textItem(tujuan),
            const SizedBox(height: 12),

            label("Detail Kegiatan"),
            textItem(detail),
            const SizedBox(height: 12),

            const SizedBox(height: 12),

            // ===========================
            // BUTTON DOWNLOAD PDF (FIXED)
            // ===========================
            OutlinedButton.icon(
              onPressed: () => downloadPDF(id),
              icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
              label: const Text(
                "Download Form Surat Tugas",
                style: TextStyle(color: Colors.red),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
              ),
            ),

            const SizedBox(height: 25),

            if (status == "disetujui") ...[
              OutlinedButton.icon(
                onPressed:
                    (isPicking || isSubmitting) ? null : pilihBukti,
                icon: const Icon(Icons.upload_file, color: Colors.orange),
                label: Text(
                  fileBukti == null
                      ? "Upload Bukti (Gambar)"
                      : fileBukti!.path.split("/").last,
                  style: const TextStyle(color: Colors.orange),
                ),
              ),

              if (fileBukti != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 160,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      fileBukti!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: (isSubmitting || isPicking)
                    ? null
                    : () => submitComplete(id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: isSubmitting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Kirim",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
