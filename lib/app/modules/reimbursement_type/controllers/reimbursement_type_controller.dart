import 'package:get/get.dart';

class ReimbursementTypeController extends GetxController {
  final types = const [
    'Biaya Bisnis',
    'Biaya Perjalanan Dinas',
    'Biaya Kesehatan',
  ];

  // Menyimpan index kartu yang diklik
  var selectedIndex = (-1).obs;

  // Method untuk memilih tipe dan navigasi
  void choose(String t, int index) {
    selectedIndex.value = index;
    Get.toNamed('/reimbursement-detail-input', arguments: {"type": t});
  }
}
