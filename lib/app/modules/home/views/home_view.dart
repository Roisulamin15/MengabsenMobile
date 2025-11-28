import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_mengabsen/app/modules/absensi/bindings/absensi_binding.dart';
import 'package:flutter_application_mengabsen/app/modules/absensi/views/absensi_view.dart';
import 'package:flutter_application_mengabsen/app/modules/edit_profil/controllers/edit_profil_controller.dart';
import 'package:flutter_application_mengabsen/app/modules/edit_profil/views/edit_profil_view.dart';
import 'package:flutter_application_mengabsen/app/modules/hrd_cuti/bindings/hrd_cuti_binding.dart';
import 'package:flutter_application_mengabsen/app/modules/hrd_cuti/views/hrd_cuti_view.dart';
import 'package:flutter_application_mengabsen/app/modules/hrd_lembur/bindings/hrd_lembur_binding.dart';
import 'package:flutter_application_mengabsen/app/modules/hrd_lembur/views/hrd_lembur_view.dart';
import 'package:flutter_application_mengabsen/app/modules/hrd_surat_tugas/bindings/hrd_surat_tugas_binding.dart';
import 'package:flutter_application_mengabsen/app/modules/hrd_surat_tugas/views/hrd_surat_tugas_view.dart';
import 'package:flutter_application_mengabsen/app/modules/lembur/bindings/lembur_binding.dart';
import 'package:flutter_application_mengabsen/app/modules/lembur/views/lembur_view.dart';
import 'package:flutter_application_mengabsen/app/modules/surat_tugas/bindings/surat_tugas_binding.dart';
import 'package:flutter_application_mengabsen/app/modules/surat_tugas/views/surat_tugas_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/home_controller.dart';
import 'package:flutter_application_mengabsen/app/modules/list_cuti/views/list_cuti_view.dart';
import 'package:flutter_application_mengabsen/app/modules/list_cuti/bindings/list_cuti_binding.dart';
import 'package:flutter_application_mengabsen/app/modules/reimbursement/views/reimbursement_view.dart';
import 'package:flutter_application_mengabsen/app/modules/reimbursement/bindings/reimbursement_binding.dart';
import 'package:flutter_application_mengabsen/app/modules/profil/views/profil_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.put(HomeController());
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _sliderTimer;
  final box = GetStorage();

  final List<String> _bannerImages = [
    "assets/banner1.png",
    "assets/banner2.png",
    "assets/banner3.png",
  ];

  @override
  void initState() {
    super.initState();
    _initializePopups();
    _startAutoSlide();
  }

  /// 🔸 Cek apakah profil sudah lengkap (berdasarkan NIK)
  Future<void> _initializePopups() async {
    await GetStorage.init();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _showBannerPopup();

      // 🔹 Ambil NIK dari penyimpanan
      String? nik = box.read('nik');

      // 🔹 Cek kelengkapan profil (hanya berdasarkan NIK)
      bool profilLengkap = nik != null && nik.isNotEmpty;

      // 🔹 Jika NIK kosong => tampilkan popup
      if (!profilLengkap) {
        print("⚠️ NIK kosong — tampilkan popup lengkapi profil");
        _showProfilPopup();
      } else {
        print("✅ NIK sudah terisi, popup tidak ditampilkan");
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _sliderTimer?.cancel();
    super.dispose();
  }

  void _startAutoSlide() {
    _sliderTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        setState(() {
          _currentPage = (_currentPage + 1) % _bannerImages.length;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // 🔶 Popup Banner
  Future<void> _showBannerPopup() async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset("assets/banner1.png", fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }

  // 🟢 Popup "Lengkapi Profil Anda"
  void _showProfilPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "Lengkapi Profil Anda",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Icon(Icons.check_circle, color: Colors.green, size: 70),
                const SizedBox(height: 16),
                const Text(
                  "Silakan lengkapi profil Anda terlebih dahulu\nuntuk melanjutkan.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Get.lazyPut(() => EditProfilController());
                      Get.to(() => EditProfilView());
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // 🔻 UI utama
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildProfileCard(),
            const SizedBox(height: 12),
            _buildMenuSection(),
            _buildBannerCarousel(),
            const SizedBox(height: 16),
            _buildAbsenSection("Absen Hari Ini", controller.absenHariIni),
            _buildAbsenSection("Absen Kemarin", controller.absenKemarin),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.camera_alt),
        onPressed: () {
          Get.to(() => AbsensiView(), binding: AbsensiBinding());
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
    );
  }

  Widget _buildProfileCard() {
    return Container(
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
            backgroundColor: Color.fromARGB(249, 183, 181, 181),
            child: Icon(Icons.person, color: Colors.white, size: 35),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Halo, ${controller.username.value}",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      controller.role.value,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _buildMenuButton(Icons.event, "Cuti", Colors.orange, () {
              final role = controller.role.value.toLowerCase();
              if (role == "hrd" || role == "pic") {
                Get.to(() => const HrdCutiView(), binding:HrdCutiBinding());
              } else {
                Get.to(() => ListCutiView(), binding: ListCutiBinding());
              }
            }),
          ),
          Expanded(
            child: _buildMenuButton(Icons.request_page, "Reimbursement", Colors.orange, () {
              Get.to(() => const ReimbursementView(), binding: ReimbursementBinding());
            }),
          ),
          Expanded(
            child: _buildMenuButton(Icons.assignment, "Surat Tugas", Colors.orange, () {
              final role = controller.role.value.toLowerCase();
              if (role == "hrd" || role == "pic") {
                Get.to(() => const HrdSuratTugasView(), binding:HrdSuratTugasBinding());
              } else {
                Get.to(() => SuratTugasView(), binding: SuratTugasBinding());
              }
            }),
          ),
          Expanded(
            child: _buildMenuButton(Icons.receipt_long, "Slip Gaji", Colors.orange, () {}),
          ),
          Expanded(
            child: _buildMenuButton(Icons.access_time, "Lembur", Colors.orange, () {
              final role = controller.role.value.toLowerCase();
              if (role == "hrd" || role == "pic") {
                Get.to(() => const HrdLemburView(), binding:HrdLemburBinding());
              } else {
                Get.to(() => LemburView(), binding: LemburBinding());
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCarousel() {
    return SizedBox(
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
    );
  }

  Widget _buildAbsenSection(String title, RxList<Map<String, String>> data) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            ...data.map((item) => Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    title: Text(item["jam"]!),
                    subtitle: Text(item["tanggal"]!),
                    trailing: Text(
                      item["status"]!,
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
          ],
        ));
  }

  Widget _buildMenuButton(IconData icon, String title, Color color, VoidCallback onTap) {
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
              color: Colors.orange,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(icon: const Icon(Icons.home, color: Colors.orange), onPressed: () {}),
          const SizedBox(width: 48),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.orange),
            onPressed: () {
              Get.to(() => ProfilView());
            },
          ),
        ],
      ),
    );
  }
}
