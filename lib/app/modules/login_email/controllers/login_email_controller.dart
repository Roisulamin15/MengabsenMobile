import 'package:flutter/material.dart';
import 'package:flutter_application_mengabsen/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_application_mengabsen/services/api_service.dart';
import '../../home/views/home_view.dart';

class LoginEmailController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var rememberMe = true.obs;
  var token = "".obs;

  final storage = GetStorage();

  void showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      "",
      messageText: SizedBox(
        height: 80,
        child: SingleChildScrollView(
          child: Text(message, style: const TextStyle(color: Colors.white)),
        ),
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

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

      if (data.containsKey('token') && data.containsKey('user')) {
        token.value = data['token'] ?? "";

        final user = data['user'] as Map<String, dynamic>? ?? {};
        final username = user['username'] ?? "Pengguna";
        final emailUser = user['email'] ?? email;
        final role = (user['role'] ?? "karyawan").toString().toLowerCase();
        final karyawanId = user['id']; // 🔹 ambil ID user dari API

        // ✅ Simpan semua ke GetStorage
        storage.write("username", username);
        storage.write("email", emailUser);
        storage.write("role", role);
        storage.write("token", token.value);
        storage.write("karyawan_id", karyawanId); // 🔹 tambahkan ini!

        print("✅ Username disimpan: $username");
        print("✅ Email disimpan: $emailUser");
        print("✅ Role disimpan: $role");
        print("✅ Karyawan ID disimpan: $karyawanId");

        // Masuk ke Home
        Get.offAll(() => const HomeView());
      } else {
        showErrorSnackbar(
            "Login Gagal", data['message'] ?? "Terjadi kesalahan");
      }
    } catch (e) {
      print("❌ Error login: $e");
      showErrorSnackbar("Error", "Gagal konek ke server: $e");
    }
  }
}
