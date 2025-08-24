import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  // Pastikan binding Flutter sudah diinisialisasi sebelum menjalankan storage
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi GetStorage dengan penanganan error
  try {
    await GetStorage.init();
  } catch (e) {
    debugPrint("❌ Gagal inisialisasi GetStorage: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Mengabsen",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      defaultTransition: Transition.fadeIn,
      theme: ThemeData(
        useMaterial3: true, // Material 3 untuk tampilan lebih modern
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
