import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://nonvaluable-gerardo-unstormed.ngrok-free.dev/api";

  // 🔹 LOGIN
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    print("🔗 [LOGIN] $url");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"email": email, "password": password}),
      );

      print("📥 [LOGIN RESPONSE] ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Login gagal: ${response.body}");
      }
    } catch (e) {
      throw Exception("Gagal konek ke server: $e");
    }
  }

  // 🔹 AJUKAN CUTI (Karyawan)
  static Future<Map<String, dynamic>> ajukanCuti(
      Map<String, dynamic> data, String token) async {
    final url = Uri.parse('$baseUrl/outdays');
    print("🔗 [AJUKAN CUTI] $url");
    print("📩 Data: $data");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(data),
      );

      print("📥 [AJUKAN CUTI RESPONSE] ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Gagal mengajukan cuti: ${response.body}");
      }
    } catch (e) {
      throw Exception("Gagal konek ke server: $e");
    }
  }

  // 🔹 GET LIST CUTI (Semua)
  static Future<List<Map<String, dynamic>>> getOutdays(String token) async {
    final url = Uri.parse('$baseUrl/outdays');
    print("🔗 [GET OUTDAYS] $url");

    try {
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("📥 [GET OUTDAYS RESPONSE] ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // Laravel biasanya kirim {"data": [...]}
        if (decoded is Map && decoded.containsKey('data')) {
          return List<Map<String, dynamic>>.from(decoded['data']);
        } else if (decoded is List) {
          return List<Map<String, dynamic>>.from(decoded);
        } else {
          return [];
        }
      } else {
        throw Exception("Gagal ambil data cuti: ${response.body}");
      }
    } catch (e) {
      throw Exception("Gagal konek ke server: $e");
    }
  }

  // 🔹 APPROVE CUTI (HRD/PIC)
  static Future<Map<String, dynamic>> approveCuti(int id, String token) async {
    final url = Uri.parse('$baseUrl/outdays/$id/approve');
    print("🔗 [APPROVE CUTI] $url");

    try {
      final response = await http.put( // ✅ Laravel pakai PUT
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("📥 [APPROVE CUTI RESPONSE] ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Gagal approve cuti: ${response.body}");
      }
    } catch (e) {
      throw Exception("Gagal konek ke server: $e");
    }
  }

  // 🔹 REJECT CUTI (HRD/PIC)
  static Future<Map<String, dynamic>> rejectCuti(int id, String token) async {
    final url = Uri.parse('$baseUrl/outdays/$id/reject');
    print("🔗 [REJECT CUTI] $url");

    try {
      final response = await http.put( // ✅ Laravel pakai PUT juga
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("📥 [REJECT CUTI RESPONSE] ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Gagal reject cuti: ${response.body}");
      }
    } catch (e) {
      throw Exception("Gagal konek ke server: $e");
    }
  }
}
