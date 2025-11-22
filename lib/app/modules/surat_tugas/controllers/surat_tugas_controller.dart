// lib/modules/surat_tugas/controllers/surat_tugas_controller.dart
import 'package:flutter_application_mengabsen/services/api_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SuratTugasController extends GetxController {
  final statusList = [
    "menunggu persetujuan",
    "disetujui",
    "selesai",
    "ditolak"
  ].obs;

  final monthList = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember",
  ].obs;

  final yearList = ["2024", "2025", "2026"].obs;

  final selectedStatus = RxnString();
  final selectedMonth = RxnString();
  final selectedYear = RxnString();

  final suratTugas = <Map<String, dynamic>>[].obs;
  final filteredSuratTugas = <Map<String, dynamic>>[].obs;

  final isLoading = false.obs;

  String? get token => GetStorage().read("token");

  @override
  void onInit() {
    super.onInit();
    fetchSuratTugas();
  }

  /// FETCH SURAT TUGAS DARI BACKEND
  Future<void> fetchSuratTugas() async {
    try {
      isLoading.value = true;

      if (token == null) {
        suratTugas.clear();
        filteredSuratTugas.clear();
        return;
      }

      final List data = await ApiService.getSuratTugas(token!);

      suratTugas.assignAll(
        data.map((e) {
          return {
            "id": e["id"],
            "judul": e["perusahaan"] ?? "Surat Tugas",
            "status": e["status"] ?? "menunggu persetujuan",
            "tanggal": e["tanggal_pengajuan"] ?? e["created_at"],
            "nama": e["karyawan"]?["name"] ?? "",
            "nik": e["karyawan"]?["nik"] ?? "",
            "jam": e["jam_pertemuan"],
            "bertemu": e["bertemu_dengan"],
            "perusahaan": e["perusahaan"],
            "bersama": e["bersama_dengan"],
            "tugas": e["tujuan_kunjungan"],
            "detail": e["detail_kunjungan"],
            "raw": e,
          };
        }).toList(),
      );

      filterSuratTugas();
    } catch (e) {
      print("Error fetch surat tugas: $e");
      Get.snackbar("Error", "Gagal mengambil data dari server");
    } finally {
      isLoading.value = false;
    }
  }

  /// ADD (LOCAL ONLY) - Optimistic UI
  void tambahSurat(Map<String, dynamic> surat) {
    suratTugas.insert(0, surat);
    filterSuratTugas();
  }

  /// RESET FILTER
  void resetFilter() {
    selectedStatus.value = null;
    selectedMonth.value = null;
    selectedYear.value = null;

    filteredSuratTugas.assignAll(suratTugas);
  }

  /// FILTER DATA
  void filterSuratTugas() {
    filteredSuratTugas.assignAll(
      suratTugas.where((surat) {
        final statusMatch =
            selectedStatus.value == null ||
                surat["status"] == selectedStatus.value;

        final monthMatch = selectedMonth.value == null ||
            surat["tanggal"].toString().contains(selectedMonth.value!);

        final yearMatch = selectedYear.value == null ||
            surat["tanggal"].toString().contains(selectedYear.value!);

        return statusMatch && monthMatch && yearMatch;
      }).toList(),
    );
  }
}
