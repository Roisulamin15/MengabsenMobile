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

  // ======================================================
  // 🔥 PERBAIKAN UTAMA: ISI DATA DI onReady()
  // ======================================================
  @override
  void onReady() {
    super.onReady();

    final nama = box.read("nama_lengkap");
    final nik = box.read("nik");

    if (nama != null && nama.toString().isNotEmpty) {
      namaController.text = nama;
    }

    if (nik != null && nik.toString().isNotEmpty) {
      nikController.text = nik.toString();
    }

    fetchCuti();
  }
  // ======================================================

  Future<void> fetchCuti() async {
    final token = box.read('token') ?? '';
    final karyawanId = _readKaryawanId();

    if (token.isEmpty || karyawanId == 0) {
      cutiList.clear();
      return;
    }

    isLoading.value = true;

    try {
      final url =
          Uri.parse("https://cmsiotanesia-edu.web.id/api/outday");

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        List<dynamic> raw = [];
        if (result is List) {
          raw = result;
        } else if (result is Map && result['data'] is List) {
          raw = result['data'];
        }

        cutiList.value = raw
            .where((e) =>
                e['karyawan_id'].toString() ==
                karyawanId.toString())
            .map<Map<String, dynamic>>(
                (e) => Map<String, dynamic>.from(e))
            .toList();
      } else {
        cutiList.clear();
      }
    } catch (_) {
      cutiList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> kirimCutiKeServer(BuildContext context) async {
    final token = box.read('token') ?? '';
    final karyawanId = _readKaryawanId();

    if (token.isEmpty || karyawanId == 0) {
      _showPopup(
        context,
        false,
        "Cuti Gagal",
        "Silakan login ulang",
      );
      return;
    }

    if (namaController.text.isEmpty ||
        nikController.text.isEmpty ||
        selectedIzin.value.isEmpty ||
        selectedJabatan.value.isEmpty) {
      _showPopup(
        context,
        false,
        "Cuti Gagal",
        "Data belum lengkap",
      );
      return;
    }

    final data = {
      "karyawan_id": karyawanId,
      "jabatan": selectedJabatan.value,
      "jenis_izin": selectedIzin.value,
      "tanggal_pengajuan": formatTanggal(tanggalPengajuan.value),
      "tanggal_izin": formatTanggal(tanggalMulai.value),
      "tanggal_selesai": formatTanggal(tanggalSelesai.value),
      "alasan": alasanController.text,
    };

    isLoading.value = true;

    try {
      final url =
          Uri.parse("https://iotanesia-edu.web.id/cms/api/outday");

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 201 ||
          response.statusCode == 200) {
        try {
          Get.find<ListCutiController>().tambahCuti({
            ...data,
            "status": "Menunggu Persetujuan",
            "karyawan": {
              "id": karyawanId,
              "nama_lengkap": namaController.text,
              "nik": nikController.text,
              "jabatan": selectedJabatan.value,
            }
          });
        } catch (_) {}

        await fetchCuti();

        _showPopup(
          context,
          true,
          "Berhasil",
          "Cuti berhasil diajukan",
        );
      } else {
        _showPopup(
          context,
          false,
          "Gagal",
          "Gagal mengirim data",
        );
      }
    } catch (e) {
      _showPopup(
        context,
        false,
        "Gagal",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showPopup(
  BuildContext context,
  bool success,
  String title,
  String message,
) {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // ================= HEADER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: success
                    ? const Color(0xFFF2994A)
                    : const Color(0xFFE74C3C),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Text(
                success ? "Cuti Berhasil Diajukan" : "Cuti Gagal Diajukan",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ================= ICON =================
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: success
                        ? const Color(0xFFE6F7EF)
                        : const Color(0xFFFDECEA),
                    shape: BoxShape.circle,
                  ),
                ),
                Icon(
                  success ? Icons.check_circle : Icons.warning_rounded,
                  size: 64,
                  color: success
                      ? const Color(0xFF27AE60)
                      : const Color(0xFFE74C3C),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ================= MESSAGE =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                success
                    ? "Permintaan berhasil diajukan.\nSilakan menunggu konfirmasi dari HRD."
                    : "Permintaan gagal diajukan karena data tidak lengkap.\nSilakan coba lagi.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9B9B9B),
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ================= BUTTON =================
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: SizedBox(
                width: 180,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF2994A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                    if (success) Get.back();
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}


  @override
  void onClose() {
    namaController.dispose();
    nikController.dispose();
    alasanController.dispose();
    super.onClose();
  }
}
