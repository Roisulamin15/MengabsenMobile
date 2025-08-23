import 'package:get/get.dart';

import '../controllers/pilih_bahasa_controller.dart';

class PilihBahasaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PilihBahasaController>(
      () => PilihBahasaController(),
    );
  }
}
