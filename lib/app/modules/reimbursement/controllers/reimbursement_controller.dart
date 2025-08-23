import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReimbursementController extends GetxController {
  /// List semua reimbursement
  var reimbursementList = <Map<String, dynamic>>[].obs;

  /// Filter dropdown
  var selectedStatus = 'Semua'.obs;
  var selectedMonth = 'Mei'.obs;
  var selectedYear = '2025'.obs;

  /// Daftar nama bulan (untuk dropdown)
  final List<String> months = const [
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
    "Desember"
  ];

  @override
  void onInit() {
    super.onInit();
    fetchReimbursements();
  }

  /// Ambil data reimbursement (awal kosong)
  void fetchReimbursements({bool withDummy = false}) {
    if (withDummy) {
      // isi dummy kalau perlu
    } else {
      reimbursementList.clear();
    }
  }

  /// Tambah reimbursement baru dari form/detail
  void addFromForm(Map<String, dynamic> data) {
    reimbursementList.add(data);
    update();
  }

  /// Hapus semua data reimbursement
  void clearAll() {
    reimbursementList.clear();
    update();
  }

  /// Navigasi ke halaman form
  void goToForm() {
    Get.toNamed('/reimbursement-form');
  }

  /// Filter reimbursement berdasarkan status, bulan, dan tahun
  List<Map<String, dynamic>> get filteredList {
    return reimbursementList.where((item) {
      // Filter status
      if (selectedStatus.value != 'Semua' &&
          item['status'] != selectedStatus.value) {
        return false;
      }

      // Parse tanggal ke DateTime
      try {
        final date = DateFormat("dd/MM/yyyy").parse(item['date']);
        final monthName = months[date.month - 1];
        final year = date.year.toString();

        // Filter bulan
        if (selectedMonth.value != monthName) return false;

        // Filter tahun
        if (selectedYear.value != year) return false;
      } catch (_) {
        // kalau date tidak bisa diparse, sembunyikan
        return false;
      }

      return true;
    }).toList();
  }
}
