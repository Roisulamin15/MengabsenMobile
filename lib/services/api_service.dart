import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://nonvaluable-gerardo-unstormed.ngrok-free.dev/api";

  // 🔹 LOGIN
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  // 🔹 GET PROFILE
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
          print('✅ Profil ditemukan dari API');
          return data['profile'];
        } else {
          print('⚠️ Struktur JSON tidak sesuai: ${response.body}');
        }
      } else {
        print('⚠️ Gagal ambil profil: ${response.statusCode} → ${response.body}');
      }
    } catch (e) {
      print('❌ Error ambil profil: $e');
    }

    return null;
  }

  // 🔹 AJUKAN CUTI
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

  // 🔹 GET LIST CUTI
  static Future<List<Map<String, dynamic>>> getOutdays(String token) async {
    final url = Uri.parse('$baseUrl/outday');

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final decoded = jsonDecode(response.body);

    if (decoded is Map && decoded.containsKey('data')) {
      return List<Map<String, dynamic>>.from(decoded['data']);
    } else if (decoded is List) {
      return List<Map<String, dynamic>>.from(decoded);
    }

    return [];
  }

  // 🔹 APPROVE CUTI
  static Future<Map<String, dynamic>> approveCuti(int id, String token) async {
    final url = Uri.parse('$baseUrl/outday/$id/approve');

    final response = await http.put(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    return jsonDecode(response.body);
  }

  // 🔹 REJECT CUTI
  static Future<Map<String, dynamic>> rejectCuti(int id, String token) async {
    final url = Uri.parse('$baseUrl/outday/$id/reject');

    final response = await http.put(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    return jsonDecode(response.body);
  }
}
