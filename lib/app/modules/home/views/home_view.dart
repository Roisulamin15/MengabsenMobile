import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_mengabsen/app/modules/cuti/bindings/cuti_binding.dart';
import 'package:flutter_application_mengabsen/app/modules/cuti/views/cuti_view.dart';
import 'package:flutter_application_mengabsen/app/modules/profil/views/profil_view.dart';
import 'package:flutter_application_mengabsen/app/modules/reimbursement/bindings/reimbursement_binding.dart';
import 'package:flutter_application_mengabsen/app/modules/reimbursement/views/reimbursement_view.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:flutter_application_mengabsen/app/modules/list_cuti/views/list_cuti_view.dart';
import 'package:flutter_application_mengabsen/app/modules/list_cuti/bindings/list_cuti_binding.dart';


class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.put(HomeController());

  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _bannerImages = [
    "assets/banner1.png",
    "assets/banner2.png",
    "assets/banner3.png",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBannerPopup();
    });
    _startAutoSlide();
  }

  void _startAutoSlide() {
    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % _bannerImages.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _showBannerPopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              "assets/banner1.png",
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header atas
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("assets/logo_kecil.png", height: 50),
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.orange),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Card Profil
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("assets/izul.jpg"),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Halo, ${controller.nama.value}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              controller.jabatan.value,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 4 Button Menu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: buildMenuButton(Icons.event, "Cuti",
                          Colors.orange, () {
                        Get.to(() =>  ListCutiView(), binding: ListCutiBinding());
                      })),

                  Expanded(
                      child: buildMenuButton(Icons.request_page,
                          "Reimbursement", Colors.orange, () {
                            Get.to(() => const ReimbursementView(),
                            binding: ReimbursementBinding());
                          })),
                  Expanded(
                      child: buildMenuButton(Icons.assignment, "Surat Tugas",
                          Colors.orange, () {})),
                  Expanded(
                      child: buildMenuButton(Icons.receipt_long, "Slip Gaji",
                          Colors.orange, () {})),
                ],
              ),
            ),

            // Banner Carousel
            SizedBox(
              height: 120,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _bannerImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(_bannerImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Absen Hari Ini
            buildAbsenSection("Absen Hari Ini", controller.absenHariIni),

            // Absen Kemarin
            buildAbsenSection("Absen Kemarin", controller.absenKemarin),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.orange),
              onPressed: () {},
            ),
            const SizedBox(width: 48),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.orange),
              onPressed: () {
                Get.to(() => const ProfilView());
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.camera_alt),
        onPressed: () {},
      ),
    );
  }

  Widget buildAbsenSection(String title, RxList<Map<String, String>> data) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            ...data.map((item) => Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    title: Text(item["jam"]!),
                    subtitle: Text(item["tanggal"]!),
                    trailing: Text(
                      item["status"]!,
                      style: const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
          ],
        ));
  }

  Widget buildMenuButton(
      IconData icon, String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.orange, // warna teks jadi oranye
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
