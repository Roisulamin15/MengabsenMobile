import 'package:get/get.dart';

import '../controllers/karyawan_absen_wfa_controller.dart';

class KaryawanAbsenWfaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KaryawanAbsenWfaController>(
      () => KaryawanAbsenWfaController(),
    );
  }
}
