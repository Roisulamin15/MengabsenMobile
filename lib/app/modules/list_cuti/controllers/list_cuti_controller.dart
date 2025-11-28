import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';

class ListCutiController extends GetxController {
  var cutiList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  final box = GetStorage();
  Timer? _timer; // 🕒 untuk auto-refresh

  /// Ambil data cuti dari server (hanya untuk karyawan yang login)
  Future<void> fetchCuti() async {
    final token = box.read('token') ?? '';
    final karyawanId = box.read('karyawan_id');

    if (token.isEmpty || karyawanId == null) {
      print("⚠️ Token atau karyawan_id belum tersedia");
      cutiList.clear();
      return;
    }

    try {
      isLoading.value = true;

      final url = Uri.parse(
        "https://iotanesia-edu.web.id/cms/api/outday?karyawan_id=$karyawanId",
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

        List<dynamic> rawList = [];

        if (result is List) {
          rawList = result;
        } else if (result is Map && result['data'] is List) {
          rawList = result['data'];
        } else {
          // format tidak dikenali
          rawList = [];
        }

        // 🔥 Filter di client side: hanya ambil yang punya karyawan_id sama dengan user login
        final filtered = rawList.where((e) {
          try {
            return e['karyawan_id'].toString() == karyawanId.toString();
          } catch (_) {
            return false;
          }
        }).map<Map<String, dynamic>>((e) {
          // pastikan item adalah Map<String, dynamic>
          if (e is Map<String, dynamic>) return e;
          return Map<String, dynamic>.from(e as Map);
        }).toList();

        cutiList.value = filtered;

        print("✅ Data cuti berhasil dimuat (${cutiList.length} item)");
        if (cutiList.isNotEmpty) {
          print("👤 Contoh data pertama: ${cutiList.first}");
        }
      } else {
        print("❌ Gagal ambil data: ${response.statusCode}");
        cutiList.clear();
      }
    } catch (e) {
      print("❌ Error fetch cuti: $e");
      cutiList.clear();
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
