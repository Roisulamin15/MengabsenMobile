import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:flutter_application_mengabsen/services/api_service.dart';

// import view utama
import '../../home/views/home_view.dart';

class LoginEmailController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var rememberMe = true.obs;
  var token = "".obs;

  final storage = GetStorage();

  /// Helper untuk menampilkan snackbar error aman dari overflow
  void showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      "",
      messageText: SizedBox(
        height: 80,
        child: SingleChildScrollView(
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showErrorSnackbar("Error", "Email dan password wajib diisi");
      return;
    }

    try {
      final data = await ApiService.login(email, password);

      if (data is! Map) {
        showErrorSnackbar("Error", "Format response tidak sesuai");
        return;
      }

      // 🔹 Sesuaikan dengan response JSON dari backend
      if (data.containsKey('token') && data.containsKey('user')) {
  token.value = data['token'] ?? "";

  final user = data['user'] as Map<String, dynamic>? ?? {};
  final username = user['username'] ?? "Pengguna";
  final emailUser = user['email'] ?? email;
  final role = (user['role'] ?? "karyawan").toString().toLowerCase();

  // Simpan data user ke GetStorage
  storage.write("username", username);
  storage.write("email", emailUser);
  storage.write("role", role);
  storage.write("token", token.value);

  print("Username disimpan: $username");
  print("Email disimpan: $emailUser");
  print("Role disimpan: $role");

  // 🔹 Setelah login masuk ke Home
  Get.offAll(() => const HomeView());
} else {
  showErrorSnackbar("Login Gagal", data['message'] ?? "Terjadi kesalahan");
}

    } catch (e) {
      print("❌ Error login: $e");
      showErrorSnackbar("Error", "Gagal konek: $e");
    }
  }
}
