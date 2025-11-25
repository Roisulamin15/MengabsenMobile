import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../services/api_service.dart';

class HrdSuratTugasController extends GetxController {
  var suratList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  // ==========================================
  // FETCH DATA SURAT TUGAS PENDING HRD
  // ==========================================
  Future<void> fetchData() async {
    try {
      isLoading(true);
      final token = box.read("token") ?? "";

      if (token.isEmpty) throw Exception("Token tidak ditemukan");

      final data = await ApiService.getSuratTugasHrd(token);
      print("📌 HRD DATA: $data");


      if (data.isNotEmpty) {
        suratList.assignAll(data);
      } else {
        suratList.clear();
      }
    } catch (e) {
      print("❌ Error Ambil Data Surat Tugas HRD: $e");
      Get.snackbar("Error", "Gagal memuat data surat tugas HRD");
      suratList.clear();
    } finally {
      isLoading(false);
    }
  }

  // ==========================================
  // APPROVE
  // ==========================================
  Future<void> approveSurat(int id) async {
    try {
      final token = box.read("token") ?? "";
      await ApiService.approveSuratTugas(id, token);

      Get.snackbar("Berhasil", "Surat tugas disetujui");
      await fetchData();
    } catch (e) {
      Get.snackbar("Error", "Gagal menyetujui: $e");
    }
  }

  // ==========================================
  // REJECT
  // ==========================================
  Future<void> rejectSurat(int id) async {
    try {
      final token = box.read("token") ?? "";
      await ApiService.rejectSuratTugas(id, token);

      Get.snackbar("Ditolak", "Surat tugas ditolak");
      await fetchData();
    } catch (e) {
      Get.snackbar("Error", "Gagal menolak: $e");
    }
  }
}
