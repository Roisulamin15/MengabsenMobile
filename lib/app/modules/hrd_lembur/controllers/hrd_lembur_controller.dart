// lib/app/modules/hrd_lembur/controllers/hrd_lembur_controller.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../services/api_service.dart';

class HrdLemburController extends GetxController {
  var lemburList = <Map<String, dynamic>>[].obs;
  var karyawanMap = <int, String>{}.obs;
  var isLoading = false.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    initController();
  }

  Future<void> initController() async {
    await fetchKaryawan();
    await fetchData();
  }

  // ======================
  // FETCH KARYAWAN
  // ======================
  Future<void> fetchKaryawan() async {
    try {
      final token = box.read("token") ?? "";
      if (token.isEmpty) return;

      final data = await ApiService.getAllKaryawan(token);
      karyawanMap.clear();

      for (var k in data) {
        final id = int.tryParse(k['id']?.toString() ?? '') ?? 0;
        final nama = (k['nama_lengkap'] ??
                k['nama'] ??
                k['name'])
            ?.toString() ??
            '-';

        if (id != 0) {
          karyawanMap[id] = nama;
        }
      }
    } catch (e) {
      print("❌ ERROR FETCH KARYAWAN: $e");
    }
  }

  // ======================
  // FETCH DATA LEMBUR HRD
  // ======================
  Future<void> fetchData() async {
    isLoading(true);
    try {
      final token = box.read("token") ?? "";
      final data = await ApiService.getLemburHrd(token);

      final list = data
          .map<Map<String, dynamic>>(
              (e) => Map<String, dynamic>.from(e))
          .toList();

      for (var item in list) {
        final rawId = item['karyawan_id']?.toString();
        final id = int.tryParse(rawId ?? '') ?? 0;

        item['nama_karyawan'] =
            item['nama_karyawan'] ??
                item['nama'] ??
                item['nama_lengkap'] ??
                item['user']?['nama_lengkap'] ??
                karyawanMap[id] ??
                '-';

        if (item['tanggal'] == null &&
            item['tanggal_lembur'] != null) {
          item['tanggal'] = item['tanggal_lembur'];
        }

        // normalize status
        item['status'] =
            (item['status'] ?? item['keterangan'] ?? 'menunggu')
                .toString()
                .toLowerCase();
      }

      // sort terbaru
      list.sort((a, b) {
        final ida = int.tryParse(a['id']?.toString() ?? '') ?? 0;
        final idb = int.tryParse(b['id']?.toString() ?? '') ?? 0;
        return idb.compareTo(ida);
      });

      lemburList.assignAll(list);
    } catch (e) {
      print("❌ ERROR FETCH HRD LEMBUR: $e");
      lemburList.clear();
    } finally {
      isLoading(false);
    }
  }

  // ======================
  // APPROVE LEMBUR
  // ======================
  Future<bool> approveLembur(int id) async {
    try {
      final token = box.read("token") ?? "";
      await ApiService.approveLembur(id, token);

      // update local list
      final index = lemburList.indexWhere((e) => e['id'] == id);
      if (index != -1) {
        lemburList[index]['status'] = 'disetujui';
        lemburList.refresh();
      }

      Get.snackbar("Berhasil", "Pengajuan lembur disetujui");
      return true;
    } catch (e) {
      Get.snackbar("Error", "Gagal menyetujui lembur");
      return false;
    }
  }

  // ======================
  // REJECT LEMBUR
  // ======================
  Future<bool> rejectLembur(int id) async {
    try {
      final token = box.read("token") ?? "";
      await ApiService.rejectLembur(id, token);

      final index = lemburList.indexWhere((e) => e['id'] == id);
      if (index != -1) {
        lemburList[index]['status'] = 'ditolak';
        lemburList.refresh();
      }

      Get.snackbar("Ditolak", "Pengajuan lembur ditolak");
      return true;
    } catch (e) {
      Get.snackbar("Error", "Gagal menolak lembur");
      return false;
    }
  }
}
