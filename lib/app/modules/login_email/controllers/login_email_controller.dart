import 'package:flutter_application_mengabsen/services/api_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../home/views/home_view.dart';

class LoginEmailController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var rememberMe = true.obs;
  var token = "".obs;

  final storage = GetStorage();

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email dan password wajib diisi",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      final data = await ApiService.login(email, password);

      if (data['success'] == true) {
        token.value = data['token'];

        final user = data['user'];

        // Simpan data user ke GetStorage
        storage.write("nama", user['name'] ?? "Pengguna");
        storage.write("email", user['email'] ?? email);
        storage.write("jabatan", user['role'] ?? "Karyawan");

         print("Nama disimpan: ${user['name']}");
         print("Email disimpan: ${user['email']}");
         print("Role disimpan: ${user['role']}");
         

        // Pindah ke dashboard
        Get.off(() => HomeView());
      } else {
        Get.snackbar("Login Gagal", data['message'] ?? "Terjadi kesalahan",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("Error login: $e");
      Get.snackbar("Error", "Gagal konek: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
