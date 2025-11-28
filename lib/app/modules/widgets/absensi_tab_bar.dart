import 'package:flutter/material.dart';

class AbsensiTabBar extends StatelessWidget {
  const AbsensiTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xffFFE6D2), // background luar
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          /// ======= TAB ABSENSI (AKTIF) =======
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xffE68540), // << warna baru
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "Absensi",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 6),

          /// ======= TAB RIWAYAT ABSENSI (NON AKTIF) =======
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xffFFD2B7), // << warna baru
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "Riwayat Absensi",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
