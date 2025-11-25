import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class ApiService {
  static const String baseUrl =
      "https://iotanesia-edu.web.id/api";

  // =========================================
  // LOGIN
  // =========================================
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json", "Accept": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  // =========================================
  // GET PROFILE
  // =========================================
  static Future<Map<String, dynamic>?> getProfile(String token) async {
    final url = Uri.parse('$baseUrl/profile');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success' && data['profile'] != null) {
          return data['profile'];
        }
      }
    } catch (e) {
      print('❌ Error ambil profil: $e');
    }

    return null;
  }

  // =========================================
  // AJUKAN CUTI
  // =========================================
  static Future<Map<String, dynamic>> ajukanCuti(
      Map<String, dynamic> data, String token) async {
    final url = Uri.parse('$baseUrl/outdays');

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(data),
    );

    return jsonDecode(response.body);
  }

  // =========================================
  // GET LIST CUTI
  // =========================================
  static Future<List<Map<String, dynamic>>> getOutdays(String token) async {
    final url = Uri.parse('$baseUrl/outday');

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    final decoded = jsonDecode(response.body);

    if (decoded is Map && decoded.containsKey('data')) {
      return List<Map<String, dynamic>>.from(decoded['data']);
    } else if (decoded is List) {
      return List<Map<String, dynamic>>.from(decoded);
    }

    return [];
  }

  // =========================================
  // APPROVE CUTI
  // =========================================
  static Future<Map<String, dynamic>> approveCuti(int id, String token) async {
    final url = Uri.parse('$baseUrl/outday/$id/approve');

    final response = await http.put(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    return jsonDecode(response.body);
  }

  // =========================================
  // REJECT CUTI
  // =========================================
  static Future<Map<String, dynamic>> rejectCuti(int id, String token) async {
    final url = Uri.parse('$baseUrl/outday/$id/reject');

    final response = await http.put(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    return jsonDecode(response.body);
  }

  // =========================================
  // GET LIST LEMBUR HRD
  // =========================================
  static Future<List<Map<String, dynamic>>> getLemburHrd(String token) async {
    final url = Uri.parse('$baseUrl/lembur');

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    final decoded = jsonDecode(response.body);

    if (decoded is Map && decoded.containsKey('data')) {
      return List<Map<String, dynamic>>.from(decoded['data']);
    } else if (decoded is List) {
      return List<Map<String, dynamic>>.from(decoded);
    }

    return [];
  }

  // =========================================
  // APPROVE LEMBUR
  // =========================================
  static Future<Map<String, dynamic>> approveLembur(int id, String token) async {
    final url = Uri.parse('$baseUrl/lembur/$id/approve');

    final response = await http.post(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal approve lembur: ${response.statusCode} → ${response.body}');
    }
  }

  // =========================================
  // REJECT LEMBUR
  // =========================================
  static Future<Map<String, dynamic>> rejectLembur(int id, String token) async {
    final url = Uri.parse('$baseUrl/lembur/$id/reject');

    final response = await http.post(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal reject lembur: ${response.statusCode} → ${response.body}');
    }
  }

  // =========================================
  // GET SEMUA KARYAWAN
  // =========================================
  static Future<List<Map<String, dynamic>>> getAllKaryawan(String token) async {
    final url = Uri.parse('$baseUrl/karyawan');

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    final decoded = jsonDecode(response.body);

    if (decoded is Map && decoded.containsKey('data')) {
      return List<Map<String, dynamic>>.from(decoded['data']);
    } else if (decoded is List) {
      return List<Map<String, dynamic>>.from(decoded);
    }

    return [];
  }

  // GET LIST SURAT TUGAS USER
  static Future<List<Map<String, dynamic>>> getSuratTugas(String token) async {
    final url = Uri.parse('$baseUrl/surat_tugas');

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    final decoded = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(decoded['data'] ?? []);
  }

  // GET DETAIL SURAT TUGAS
  static Future<Map<String, dynamic>> getSuratTugasDetail(int id, String token) async {
    final url = Uri.parse('$baseUrl/surat_tugas/$id');

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("STATUS DETAIL: ${response.statusCode}");
    print("BODY DETAIL: ${response.body}");

    final decoded = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception("HTTP ${response.statusCode}: ${response.body}");
    }

    if (decoded is Map && decoded['data'] != null) {
      return Map<String, dynamic>.from(decoded['data']);
    }

    if (decoded is Map && decoded['surat_tugas'] != null) {
      return Map<String, dynamic>.from(decoded['surat_tugas']);
    }

    throw Exception("Format API tidak sesuai (tidak ada 'data' atau 'surat_tugas')");
  }

  // SUBMIT SURAT TUGAS
  static Future<Map<String, dynamic>> submitSuratTugasBaru(
      Map<String, dynamic> fields, String token) async {
    final url = Uri.parse('$baseUrl/surat_tugas');

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(fields),
    );

    final decoded = jsonDecode(response.body);
    return Map<String, dynamic>.from(decoded);
  }

  // COMPLETE SURAT TUGAS
  static Future<Map<String, dynamic>> completeSuratTugas(
      int id, String jamSelesai, File? fileTtd, String token) async {
    final uri = Uri.parse('$baseUrl/surat_tugas/$id/complete');
    final request = http.MultipartRequest("POST", uri);

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    request.fields['jam_selesai'] = jamSelesai;

    if (fileTtd != null && fileTtd.existsSync()) {
      request.files.add(await http.MultipartFile.fromPath("file_ttd", fileTtd.path));
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal complete surat tugas");
    }
  }

 // GET ALL SURAT TUGAS UNTUK HRD
static Future<List<Map<String, dynamic>>> getSuratTugasHrd(String token) async {
  final url = Uri.parse('$baseUrl/surat_tugas/all');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  print("STATUS HRD: ${response.statusCode}");
  print("BODY HRD: ${response.body}");

  if (response.statusCode != 200) return [];

  final body = jsonDecode(response.body);

  if (body is Map && body['data'] != null) {
    return List<Map<String, dynamic>>.from(body['data']);
  }

  return [];
}




  // =========================================
  // APPROVE SURAT TUGAS (PERBAIKAN)
  // =========================================
  static Future<Map<String, dynamic>> approveSuratTugas(int id, String token) async {
    final url = Uri.parse('$baseUrl/surat_tugas/$id/approve');

    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    return jsonDecode(response.body);
  }

  // =========================================
  // REJECT SURAT TUGAS (PERBAIKAN)
  // =========================================
  static Future<Map<String, dynamic>> rejectSuratTugas(int id, String token) async {
    final url = Uri.parse('$baseUrl/surat_tugas/$id/reject');

    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    return jsonDecode(response.body);
  }
}
