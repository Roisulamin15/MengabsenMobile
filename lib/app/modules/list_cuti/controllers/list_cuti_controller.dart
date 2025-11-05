import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

    class ListCutiController extends GetxController {
      var cutiList = <Map<String, dynamic>>[].obs;
      var isLoading = false.obs;
      final box = GetStorage();
      Timer? _timer; // 🕒 untuk auto-refresh

      /// Ambil data cuti dari server
      Future<void> fetchCuti() async {
      final token = box.read('token') ?? '';
      final karyawanId = box.read('karyawan_id');

      if (token.isEmpty || karyawanId == null) {
        print("⚠️ Token atau karyawan_id belum tersedia");
        return;
      }

      try {
        isLoading.value = true;

        final url = Uri.parse(
          "https://nonvaluable-gerardo-unstormed.ngrok-free.dev/api/outday?karyawan_id=$karyawanId",
        );

        final response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final result = json.decode(response.body);

          // ✅ Ganti bagian ini dengan yang baru:
          if (result is List) {
            cutiList.value = result.map<Map<String, dynamic>>((e) {
              return {
                ...e,
                "karyawan": e["karyawan"], // ✅ pastikan relasi ikut
              };
            }).toList();
          } else if (result is Map && result['data'] is List) {
            cutiList.value = (result['data'] as List).map<Map<String, dynamic>>((e) {
              return {
                ...e,
                "karyawan": e["karyawan"], // ✅ pastikan relasi ikut
              };
            }).toList();
          } else {
            print("⚠️ Format data tidak dikenali, kosongkan list");
            cutiList.clear();
          }

          print("✅ Data cuti berhasil dimuat (${cutiList.length} item)");
          if (cutiList.isNotEmpty) {
            print("👤 Contoh data pertama: ${cutiList.first}");
          }
        } else {
          print("❌ Gagal ambil data: ${response.statusCode}");
        }
      } catch (e) {
        print("❌ Error fetch cuti: $e");
      } finally {
        isLoading.value = false;
      }
    }


  /// Tambah data lokal (setelah kirim cuti sukses)
  void tambahCuti(Map<String, dynamic> data) {
    cutiList.insert(0, data);
  }

  /// Auto refresh setiap 5 detik
  void startAutoRefresh() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await fetchCuti();
    });
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 500), () async {
      await fetchCuti();
      startAutoRefresh(); // 🕒 mulai auto-refresh
    });
  }

  @override
  void onClose() {
    _timer?.cancel(); // hentikan timer jika halaman ditutup
    super.onClose();
  }
}
