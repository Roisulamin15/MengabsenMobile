import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class LemburController extends GetxController {
  final box = GetStorage();

  final daftarLembur = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  var selectedStatus = RxnString();
  var selectedMonth = RxnString();
  var selectedYear = RxnString();

  final statusList = ["Semua", "Menunggu", "Disetujui", "Ditolak"];
  final monthList = [
    "Januari", "Februari", "Maret", "April", "Mei", "Juni",
    "Juli", "Agustus", "September", "Oktober", "November", "Desember"
  ];
  final yearList = ["2022", "2023", "2024", "2025", "2026"];

  final String baseUrl = "https://iotanesia-edu.web.id/cms/api/lembur";

  @override
  void onInit() {
    super.onInit();
    loadLocal();
    fetchLembur();
    _startAutoRefresh();
  }

  void _startAutoRefresh() async {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      await fetchLembur();
      return true;
    });
  }

  void loadLocal() {
    final saved = box.read('daftarLembur');
    if (saved != null && saved is List) {
      try {
        daftarLembur.value = List<Map<String, dynamic>>.from(saved);
      } catch (_) {
        daftarLembur.clear();
      }
    }
  }

  Future<void> fetchLembur() async {
    isLoading.value = true;
    final token = box.read('token') ?? '';
    final rawId = box.read('karyawan_id');
    final karyawanIdStr = rawId?.toString();

    try {
      final res = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Accept': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
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

        final mapped = rawList.map<Map<String, dynamic>>((e) {
          final m = Map<String, dynamic>.from(e);
          if (m['tanggal'] == null && m['tanggal_lembur'] != null) {
            m['tanggal'] = m['tanggal_lembur'];
          }
          m['status'] = m['status'] ?? "Menunggu";
          return m;
        }).toList();

        final filtered = (karyawanIdStr != null)
            ? mapped.where((m) => m['karyawan_id']?.toString() == karyawanIdStr).toList()
            : mapped;

        daftarLembur.value = filtered;
        box.write('daftarLembur', daftarLembur);
      }
    } catch (e) {
      print("Fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void addLembur(Map<String, dynamic> lembur) {
    if (lembur['tanggal'] == null && lembur['tanggal_lembur'] != null) {
      lembur['tanggal'] = lembur['tanggal_lembur'];
    }
    lembur['status'] = lembur['status'] ?? 'Menunggu';

    daftarLembur.insert(0, Map<String, dynamic>.from(lembur));
    box.write('daftarLembur', daftarLembur);
  }

  Future<bool> approveLembur(dynamic id) async {
    final token = box.read('token') ?? '';
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/$id/approve'),
        headers: {
          'Accept': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        final idx = daftarLembur.indexWhere((e) => e['id'].toString() == id.toString());
        if (idx != -1) {
          daftarLembur[idx]['status'] = 'Disetujui';
          box.write('daftarLembur', daftarLembur);
        }
        return true;
      }
    } catch (_) {}
    return false;
  }

  Future<bool> rejectLembur(dynamic id) async {
    final token = box.read('token') ?? '';
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/$id/reject'),
        headers: {
          'Accept': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        final idx = daftarLembur.indexWhere((e) => e['id'].toString() == id.toString());
        if (idx != -1) {
          daftarLembur[idx]['status'] = 'Ditolak';
          box.write('daftarLembur', daftarLembur);
        }
        return true;
      }
    } catch (_) {}
    return false;
  }
}
