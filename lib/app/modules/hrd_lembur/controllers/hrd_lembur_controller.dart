    import 'package:get/get.dart';
    import 'package:get_storage/get_storage.dart';
    import '../../../../services/api_service.dart';

    class HrdLemburController extends GetxController {
      var lemburList = <Map<String, dynamic>>[].obs;
      var karyawanMap = <int, String>{}.obs; // map id -> nama
      var isLoading = false.obs;
      final box = GetStorage();

      @override
      void onInit() {
        super.onInit();
        initController();
      }

      // ======== INIT CONTROLLER =========
      Future<void> initController() async {
        await fetchKaryawan(); // tunggu karyawan selesai
        await fetchData();     // baru fetch data lembur
      }

      // ================================
      // FETCH KARYAWAN
      // ================================
      Future<void> fetchKaryawan() async {
        try {
          final token = box.read("token") ?? "";
          if (token.isEmpty) throw Exception("Token tidak ditemukan");

          final data = await ApiService.getAllKaryawan(token);

          // jika API bungkus data di 'data' field
          final list = data as List;

          for (var k in list) {
            int id = k["id"];
            String nama = k["nama_lengkap"] ?? "-";
            karyawanMap[id] = nama;
          }

          print("Karyawan Map => $karyawanMap");
        } catch (e) {
          print("❌ ERROR FETCH KARYAWAN: $e");
        }
      }

      // ================================
      // FETCH DATA LEMBUR HRD
      // ================================
      Future<void> fetchData() async {
        try {
          isLoading(true);

          final token = box.read("token") ?? "";
          if (token.isEmpty) throw Exception("Token tidak ditemukan");

          final data = await ApiService.getLemburHrd(token);

          print("===== DATA DARI API HRD =====");
          for (var item in data) {
            print(item);

            // contoh replace karyawan_id dengan nama
            int idKaryawan = int.parse(item['karyawan_id'].toString());
            item['nama_karyawan'] = karyawanMap[idKaryawan] ?? '-';
          }
          print("===== END DATA =====");

          lemburList.assignAll(data);
        } catch (e) {
          print("❌ ERROR FETCH HRD LEMBUR: $e");
          Get.snackbar("Error", "Gagal memuat data lembur");
          lemburList.clear();
        } finally {
          isLoading(false);
        }
      }

      // ======== APPROVE =========
      Future<void> approveLembur(int id) async {
        try {
          final token = box.read("token") ?? "";
          await ApiService.approveLembur(id, token);

          Get.snackbar("Berhasil", "Pengajuan lembur disetujui");
          await fetchData();
        } catch (e) {
          Get.snackbar("Error", "Gagal menyetujui: $e");
        }
      }

      // ======== REJECT =========
      Future<void> rejectLembur(int id) async {
        try {
          final token = box.read("token") ?? "";
          await ApiService.rejectLembur(id, token);

          Get.snackbar("Ditolak", "Pengajuan lembur ditolak");
          await fetchData();
        } catch (e) {
          Get.snackbar("Error", "Gagal menolak: $e");
        }
      }
    }
