import 'package:flutter/material.dart';
import 'package:flutter_application_mengabsen/app/modules/list_cuti/controllers/list_cuti_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CutiController extends GetxController {
  final box = GetStorage();

  var cutiList = <Map<String, dynamic>>[].obs;
  var selectedJabatan = "".obs;
  var selectedIzin = "".obs;
  var tanggalPengajuan = DateTime.now().obs;
  var tanggalMulai = DateTime.now().obs;
  var tanggalSelesai = DateTime.now().obs;
  var isLoading = false.obs;

  final namaController = TextEditingController();
  final nikController = TextEditingController();
  final alasanController = TextEditingController();

  final List<String> jabatanList = [
    "Project Manager",
    "Head of Business Analyst",
    "Head of IT Development",
    "Head of IT Operation",
    "Head Admin & Finance",
    "Business Analyst",
    "Lead Backend and Middleware",
    "Lead of Mobile Developer",
    "Lead of UI/UX Designer",
    "Backend and Middleware Developer",
    "System Analyst",
    "Frontend Developer",
    "Mobile Developer",
    "UI/UX Designer",
    "QA and IT Support",
    "HRD",
    "PIC",
    "Project & Admin Assistant",
  ];

  final List<String> izinList = ["Sakit", "Izin", "Cuti"];

  String formatTanggal(DateTime date) {
    return DateFormat("yyyy-MM-dd").format(date);
  }

  int _readKaryawanId() {
    final raw = box.read('karyawan_id');
    if (raw == null) return 0;
    if (raw is int) return raw;
    return int.tryParse(raw.toString()) ?? 0;
  }

  /// Ambil list cuti dari server (hanya milik karyawan ini)
  Future<void> fetchCuti() async {
    final token = box.read('token') ?? '';
    final karyawanId = _readKaryawanId();

    if (token.isEmpty || karyawanId == 0) {
      Get.snackbar("Error", "Token atau ID karyawan tidak ditemukan",
          backgroundColor: Colors.red, colorText: Colors.white);
      cutiList.clear();
      return;
    }

    isLoading.value = true;

    try {
      final url = Uri.parse(
          "https://cms.iotanesia-edu.web.id/api/outday"
          );
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        // Ambil list dari berbagai bentuk response
        List<dynamic> raw = [];
        if (result is List) raw = result;
        else if (result is Map && result['data'] is List) raw = result['data'];
        else raw = [];

        // Filter (double-safety) berdasarkan karyawan_id
        final filtered = raw.where((e) {
          try {
            return e['karyawan_id'].toString() == karyawanId.toString();
          } catch (_) {
            return false;
          }
        }).map<Map<String, dynamic>>((e) {
          if (e is Map<String, dynamic>) return e;
          return Map<String, dynamic>.from(e as Map);
        }).toList();

        cutiList.value = filtered;
      } else {
        cutiList.clear();
        Get.snackbar("Error", "Gagal memuat data cuti (${response.statusCode})",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      cutiList.clear();
      Get.snackbar("Error", "Terjadi kesalahan: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  /// Kirim data cuti ke server
  Future<void> kirimCutiKeServer(BuildContext context) async {
    final token = box.read('token') ?? '';
    final karyawanId = _readKaryawanId();

    if (token.isEmpty || karyawanId == 0) {
      _showPopup(context, false, "Cuti Gagal Diajukan",
          "Token atau ID karyawan tidak ditemukan. Silakan login ulang.");
      return;
    }

    if (namaController.text.isEmpty ||
        nikController.text.isEmpty ||
        selectedIzin.value.isEmpty ||
        selectedJabatan.value.isEmpty) {
      _showPopup(context, false, "Cuti Gagal Diajukan",
          "Data belum lengkap. Silakan isi semua field.");
      return;
    }

    final data = {
      "karyawan_id": karyawanId, // INT (penting)
      "jabatan": selectedJabatan.value,
      "jenis_izin": selectedIzin.value,
      "tanggal_pengajuan": formatTanggal(tanggalPengajuan.value),
      "tanggal_izin": formatTanggal(tanggalMulai.value),
      "tanggal_selesai": formatTanggal(tanggalSelesai.value),
      "alasan": alasanController.text,
    };

    isLoading.value = true;

    try {
      final url = Uri.parse(
          "https://iotanesia-edu.web.id/cms/api/outday");
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      final result = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        // update local list view utama (ListCutiController) jika ada
        try {
          final listController = Get.find<ListCutiController>();
          final localItem = {
            // bentuk lokal agar konsisten dengan server response minimal
            "id": result is Map && result['data']?['id'] != null
                ? result['data']['id']
                : DateTime.now().millisecondsSinceEpoch,
            "karyawan_id": karyawanId,
            "jabatan": selectedJabatan.value,
            "jenis_izin": selectedIzin.value,
            "tanggal_pengajuan": formatTanggal(tanggalPengajuan.value),
            "tanggal_izin": formatTanggal(tanggalMulai.value),
            "tanggal_selesai": formatTanggal(tanggalSelesai.value),
            "alasan": alasanController.text,
            "status": result is Map && result['data']?['status'] != null
                ? result['data']['status']
                : "Menunggu Persetujuan",
            // tambahkan subobject karyawan agar UI bisa menampilkan nama & nik
            "karyawan": {
              "id": karyawanId,
              "nama_lengkap": namaController.text,
              "nik": nikController.text,
               "jabatan": selectedJabatan.value,
            }
          };
          listController.tambahCuti(localItem);
        } catch (_) {
          // jika ListCutiController tidak ditemukan, skip
        }

        // juga tambahkan ke cutiList lokal di halaman pengajuan (opsional)
        cutiList.insert(
            0,
            {
              ...data,
              "status": "Menunggu Persetujuan",
              "karyawan": {
                "id": karyawanId,
                "nama_lengkap": namaController.text,
                "nik": nikController.text,
              }
            });

        await fetchCuti(); // refresh dari server (lebih authoritative)
        _showPopup(context, true, "Cuti Berhasil Diajukan",
            "Permintaan berhasil diajukan. Silahkan menunggu konfirmasi dari HRD.");
      } else {
        _showPopup(context, false, "Cuti Gagal Diajukan",
            result is Map ? (result['message'] ?? "Gagal mengirim data.") : "Gagal mengirim data.");
      }
    } catch (e) {
      _showPopup(context, false, "Cuti Gagal Diajukan",
          "Terjadi kesalahan koneksi: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Pop-up konfirmasi
  void _showPopup(
      BuildContext context, bool success, String title, String message) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: success ? Colors.orange : Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Icon(
              success ? Icons.check_circle : Icons.error,
              color: success ? Colors.green : Colors.red,
              size: 64,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(100, 40),
              ),
              onPressed: () {
                Get.back(); // tutup popup
                if (success) {
                  fetchCuti();
                  Get.back(); // balik ke ListCutiView
                }
              },
              child: const Text("OK",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            )
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onInit() {
    super.onInit();
    fetchCuti();
  }

  @override
  void onClose() {
    namaController.dispose();
    nikController.dispose();
    alasanController.dispose();
    super.onClose();
  }
}
