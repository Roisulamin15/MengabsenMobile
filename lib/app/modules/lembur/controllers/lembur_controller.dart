import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LemburController extends GetxController {
  final box = GetStorage();
  var daftarLembur = <Map<String, dynamic>>[].obs;

  var selectedStatus = RxnString();
  var selectedMonth = RxnString();
  var selectedYear = RxnString();

  final statusList = ["Semua", "Menunggu", "Disetujui", "Ditolak"];
  final monthList = ["Januari", "Februari", "Maret", "April", "Mei"];
  final yearList = ["2022", "2023", "2024", "2025"];

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  /// 🔹 Muat data awal (dummy + lokal)
  void loadData() {
    // Baca data dari GetStorage
    final savedData = box.read('daftarLembur');

    if (savedData != null && savedData is List) {
      daftarLembur.value = List<Map<String, dynamic>>.from(savedData);
    } else {
      // Jika belum ada data tersimpan → pakai data dummy dulu
      daftarLembur.assignAll([
        {
          'tanggal': '19/05/2022',
          'jamMulai': '18:00',
          'jamSelesai': '21:00',
          'keterangan': 'Lembur Pengerjaan Laporan',
          'status': 'Menunggu'
        },
        {
          'tanggal': '20/05/2022',
          'jamMulai': '17:30',
          'jamSelesai': '20:30',
          'keterangan': 'Lembur Dokumentasi',
          'status': 'Disetujui'
        },
        {
          'tanggal': '22/05/2022',
          'jamMulai': '19:00',
          'jamSelesai': '22:00',
          'keterangan': 'Lembur Backup Server',
          'status': 'Ditolak'
        },
      ]);
      // Simpan data awal ke storage biar bisa lanjut disimpan nanti
      box.write('daftarLembur', daftarLembur);
    }
  }

  /// ✅ Tambahkan lembur baru dari form
  void addLembur(Map<String, dynamic> lembur) {
    daftarLembur.add(lembur);
    box.write('daftarLembur', daftarLembur); // Simpan setiap kali tambah data
  }

  /// 🔹 Hapus semua data (opsional untuk debug)
  void clearLembur() {
    daftarLembur.clear();
    box.remove('daftarLembur');
  }
}
