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

  Future<void> fetchKaryawan() async {
    try {
      final token = box.read("token") ?? "";
      if (token.isEmpty) return;
      final data = await ApiService.getAllKaryawan(token);
      karyawanMap.clear();
      for (var k in data) {
        final id = int.tryParse(k['id']?.toString() ?? '') ?? 0;
        final nama = (k['nama_lengkap'] ?? k['nama'] ?? k['name'])?.toString() ?? '-';
        if (id != 0) karyawanMap[id] = nama;
      }
    } catch (e) {
      print("❌ ERROR FETCH KARYAWAN: $e");
    }
  }

  Future<void> fetchData() async {
    isLoading(true);
    try {
      final token = box.read("token") ?? "";
      final data = await ApiService.getLemburHrd(token);

      final list = data.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList();

      // mapping nama_karyawan fallback
      for (var item in list) {
        final rawId = item['karyawan_id']?.toString();
        final id = int.tryParse(rawId ?? '') ?? 0;
        item['nama_karyawan'] = 
      item['nama_karyawan'] 
      ?? item['nama'] 
      ?? item['nama_lengkap']
      ?? item['user']?['nama_lengkap']
      ?? karyawanMap[id] 
      ?? '-';


        if (item['tanggal'] == null && item['tanggal_lembur'] != null) {
          item['tanggal'] = item['tanggal_lembur'];
        }
        // normalize status
        item['status'] = (item['status'] ?? item['keterangan'] ?? 'Menunggu').toString();
      }

      // sort: newest first (prefer id, fallback created_at)
      list.sort((a, b) {
        if (a.containsKey('id') && b.containsKey('id')) {
          try {
            return (b['id'] as dynamic).compareTo(a['id'] as dynamic);
          } catch (_) {}
        }
        final da = DateTime.tryParse(a['created_at']?.toString() ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
        final db = DateTime.tryParse(b['created_at']?.toString() ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
        return db.compareTo(da);
      });

      lemburList.assignAll(list);
    } catch (e) {
      print("❌ ERROR FETCH HRD LEMBUR: $e");
      lemburList.clear();
    } finally {
      isLoading(false);
    }
  }

  Future<void> approveLembur(int id) async {
    try {
      final token = box.read("token") ?? "";
      final resp = await ApiService.approveLembur(id, token);
      Get.snackbar("Berhasil", "Pengajuan lembur disetujui");
      // refetch data supaya server state sinkron
      await fetchData();

      // try update user local list if exists
      try {
        final lemburController = Get.find<dynamic>(tag: 'lemburController');
        // fallback: try without tag
        if (lemburController != null) {
          await lemburController.updateStatusLocal(id, 'Disetujui');
        }
      } catch (_) {}
    } catch (e) {
      Get.snackbar("Error", "Gagal menyetujui: $e");
    }
  }

  Future<void> rejectLembur(int id) async {
    try {
      final token = box.read("token") ?? "";
      final resp = await ApiService.rejectLembur(id, token);
      Get.snackbar("Ditolak", "Pengajuan lembur ditolak");
      await fetchData();

      try {
        final lemburController = Get.find<dynamic>(tag: 'lemburController');
        if (lemburController != null) {
          await lemburController.updateStatusLocal(id, 'Ditolak');
        }
      } catch (_) {}
    } catch (e) {
      Get.snackbar("Error", "Gagal menolak: $e");
    }
  }
}
