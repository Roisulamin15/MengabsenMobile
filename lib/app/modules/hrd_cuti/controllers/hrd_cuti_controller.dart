import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../services/api_service.dart';

class HrdCutiController extends GetxController {
  var cutiList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading(true);
      final token = box.read('token') ?? "";

      if (token.isEmpty) throw Exception("Token tidak ditemukan");

      final data = await ApiService.getOutdays(token);

      if (data.isNotEmpty) {
        cutiList.assignAll(data);
      } else {
        cutiList.clear();
      }
    } catch (e) {
      print("❌ Error Ambil Data HRD Cuti: $e");
      Get.snackbar("Error", "Gagal memuat data cuti HRD");
      cutiList.clear();
    } finally {
      isLoading(false);
    }
  }

  Future<void> approveCuti(int id) async {
    try {
      final token = box.read('token') ?? "";
      await ApiService.approveCuti(id, token);
      Get.snackbar("Berhasil", "Pengajuan cuti disetujui");
      await fetchData();
    } catch (e) {
      Get.snackbar("Error", "Gagal menyetujui: $e");
    }
  }

  Future<void> rejectCuti(int id) async {
    try {
      final token = box.read('token') ?? "";
      await ApiService.rejectCuti(id, token);
      Get.snackbar("Ditolak", "Pengajuan cuti ditolak");
      await fetchData();
    } catch (e) {
      Get.snackbar("Error", "Gagal menolak: $e");
    }
  }
}
