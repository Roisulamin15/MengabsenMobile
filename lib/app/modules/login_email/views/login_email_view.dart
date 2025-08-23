import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_email_controller.dart';
import '../../../routes/app_pages.dart';

class LoginEmailView extends GetView<LoginEmailController> {
  const LoginEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Biar layout menyesuaikan saat keyboard muncul
      body: SafeArea(
        child: SingleChildScrollView(
          // Scroll biar tidak overflow di layar kecil
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back + title
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Get.back(),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Masuk dengan Email",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Header text
                    const Text(
                      "Selamat datang",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Masuk dulu yuk dengan pakai akunmu",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 30),

                    // Email field
                    TextField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon:
                            const Icon(Icons.email, color: Colors.orange),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    TextField(
                      controller: controller.passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon:
                            const Icon(Icons.lock, color: Colors.orange),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.LUPA_PASSWORD);
                        },
                        child: const Text(
                          "Lupa password ?",
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ),

                    // Remember me
                    Row(
                      children: [
                        Obx(() => Checkbox(
                              value: controller.rememberMe.value,
                              activeColor: Colors.orange,
                              onChanged: (value) => controller.rememberMe.value =
                                  value ?? false,
                            )),
                        const Text("Ingat saya"),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.login();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Masuk",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Footer
                    Center(
                      child: Column(
                        children: [
                          Image.asset("assets/logo_kecil.png", height: 30),
                          const SizedBox(height: 5),
                          Image.asset("assets/Powerby.png", height: 15),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
