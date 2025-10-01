import 'package:get/get.dart';
import '../controllers/karyawan_absen_controller.dart';

class KaryawanAbsenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KaryawanAbsenController>(() => KaryawanAbsenController());
  }
}
