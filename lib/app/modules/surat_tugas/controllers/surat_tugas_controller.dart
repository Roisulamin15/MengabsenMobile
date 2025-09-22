import 'package:get/get.dart';


class SuratTugasController extends GetxController {
  // Dropdown filter options
  final statusList = ["Proses", "Selesai", "Ditolak"].obs;
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

  // Selected values
  final selectedStatus = RxnString();
  final selectedMonth = RxnString();
  final selectedYear = RxnString();

  // Data Surat Tugas (Dummy)
  final suratTugas = <Map<String, dynamic>>[
    // {
    //   "judul": "Perjalanan Dinas Bandung",
    //   "status": "Selesai",
    //   "tanggal": "10 Januari 2025",
    //   "nama": "Budi Setiawan",
    //   "nik": "1234567890",
    //   "jam": "08:00",
    //   "bertemu": "PT. XYZ",
    //   "perusahaan": "PT. Teknologi Nusantara",
    //   "bersama": "Tim Audit",
    //   "tugas": "Meeting Proyek",
    //   "detail": "Membahas progress proyek IT di Bandung"
    // },
    // {
    //   "judul": "Survey Proyek Jakarta",
    //   "status": "Proses",
    //   "tanggal": "5 Februari 2025",
    //   "nama": "Siti Rahmawati",
    //   "nik": "9876543210",
    //   "jam": "09:00",
    //   "bertemu": "Pemda DKI",
    //   "perusahaan": "Pemda DKI Jakarta",
    //   "bersama": "Tim Surveyor",
    //   "tugas": "Survey Lokasi",
    //   "detail": "Survey lahan untuk pembangunan kantor pusat"
    // },
  ].obs;

  // Filtered data
  final filteredSuratTugas = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    filteredSuratTugas.assignAll(suratTugas);
  }

  // Tambah surat baru
  void tambahSurat(Map<String, dynamic> surat) {
    suratTugas.add(surat);
    filterSuratTugas();
  }

  // Reset filter dan tampilkan semua surat
  void resetFilter() {
    selectedStatus.value = null;
    selectedMonth.value = null;
    selectedYear.value = null;
    filteredSuratTugas.assignAll(suratTugas);
  }

  // Filter berdasarkan status, bulan, tahun
  void filterSuratTugas() {
    filteredSuratTugas.assignAll(suratTugas.where((surat) {
      final statusMatch = selectedStatus.value == null ||
          surat["status"] == selectedStatus.value;

      final monthMatch = selectedMonth.value == null ||
          surat["tanggal"].toString().contains(selectedMonth.value!);

      final yearMatch = selectedYear.value == null ||
          surat["tanggal"].toString().contains(selectedYear.value!);

      return statusMatch && monthMatch && yearMatch;
    }).toList());
  }
}
