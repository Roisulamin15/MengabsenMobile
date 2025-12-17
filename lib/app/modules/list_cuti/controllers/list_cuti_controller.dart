import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ListCutiController extends GetxController {
  final box = GetStorage();

  final cutiList = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  final String baseUrl =
      "https://iotanesia-edu.web.id/cms/api/outday";

  @override
  void onInit() {
    super.onInit();
    fetchCuti(); // ✅ cukup sekali
  }

  Future<void> fetchCuti() async {
    isLoading.value = true;

    final token = box.read('token') ?? '';
    final rawId = box.read('karyawan_id');
    final karyawanId = rawId?.toString();

    if (token.isEmpty || karyawanId == null) {
      cutiList.clear();
      isLoading.value = false;
      return;
    }

    try {
      final res = await http.get(
        Uri.parse("$baseUrl?karyawan_id=$karyawanId"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);

        List<dynamic> rawList = [];
        if (decoded is Map && decoded['data'] is List) {
          rawList = decoded['data'];
        } else if (decoded is List) {
          rawList = decoded;
        }

        final mapped = rawList
            .map<Map<String, dynamic>>(
              (e) => Map<String, dynamic>.from(e),
            )
            .where(
              (e) =>
                  e['karyawan_id']?.toString() ==
                  karyawanId,
            )
            .toList();

        cutiList.value = mapped;
      } else {
        cutiList.clear();
      }
    } catch (e) {
      cutiList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// dipanggil setelah submit cuti
  void tambahCuti(Map<String, dynamic> data) {
    cutiList.insert(0, Map<String, dynamic>.from(data));
  }
}
