import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_mengabsen/app/modules/widgets/absen_lokasi_selector.dart';
import 'package:flutter_application_mengabsen/app/modules/widgets/izin_form.dart';
import 'package:flutter_application_mengabsen/app/modules/widgets/selfie_widget.dart';
import 'package:flutter_application_mengabsen/app/modules/widgets/map_widget.dart';
import 'package:flutter_application_mengabsen/app/modules/widgets/absensi_tab_bar.dart';
import 'package:flutter_application_mengabsen/app/modules/absensi/controllers/absensi_controller.dart';


class AbsensiView extends StatelessWidget {
  final AbsensiController controller = Get.put(AbsensiController());

  AbsensiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Absensi",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ============== TAB ABSENSI / RIWAYAT ===============
              AbsensiTabBar(),
              const SizedBox(height: 20),

              /// ============== PILIHAN LOKASI ABSEN =================
              AbsenLokasiSelector(),
              const SizedBox(height: 20),

             /// ============== TIDAK MASUK KERJA ======================
              if (controller.selectedOption.value == "Tidak Masuk") ...[
                IzinForm(),
                const SizedBox(height: 20),

                /// ==== Tombol Submit (Tidak Masuk Kerja) ====
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffF6A96C),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: controller.submitAbsensi,
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],


              /// ============== WFO / WFH / WFA ========================
              if (controller.selectedOption.value == "WFO" ||
                  controller.selectedOption.value == "WFH" ||
                  controller.selectedOption.value == "WFA") ...[

                /// ==== dropdown lokasi dinamis ====
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          controller.selectedOption.value == "WFO"
                              ? "Alamat Kantor"
                              : "Alamat Rumah",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

             /// ==== MAP ====
              MapWidget(
                latitude: controller.latitude.value,
                longitude: controller.longitude.value,
              ),
              const SizedBox(height: 20),


                /// ==== Selfie ====
                SelfieWidget(),
                const SizedBox(height: 10),

                /// ==== Tombol Absen ====
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffF6A96C),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: controller.submitAbsensi,
                    child: const Text(
                      "Absen",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 25),

              /// ================= Waktu =====================
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 10),
                    Text(
                      controller.waktu.value,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),

              /// ================= Tanggal ====================
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month),
                    const SizedBox(width: 10),
                    Text(
                      controller.tanggal.value,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),

            ],
          ),
        );
      }),
    );
  }
}
