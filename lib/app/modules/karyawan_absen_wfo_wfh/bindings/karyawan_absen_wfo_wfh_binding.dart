import 'package:get/get.dart';

import '../controllers/karyawan_absen_wfo_wfh_controller.dart';

class KaryawanAbsenWfoWfhBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KaryawanAbsenWfoWfhController>(
      () => KaryawanAbsenWfoWfhController(),
    );
  }
}
