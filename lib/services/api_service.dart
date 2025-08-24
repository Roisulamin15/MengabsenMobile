import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://incredible-art-production.up.railway.app/api";

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    print("🔗 [LOGIN] URL: $url");
    print("📩 [LOGIN] Sending => { email: $email, password: $password }");

    try {
      final response = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 15));

      print("✅ [LOGIN] Status: ${response.statusCode}");
      print("📥 [LOGIN] Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 401) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print("❌ [LOGIN] Error: $e");
      throw Exception("Gagal konek ke server: $e");
    }
  }
}
