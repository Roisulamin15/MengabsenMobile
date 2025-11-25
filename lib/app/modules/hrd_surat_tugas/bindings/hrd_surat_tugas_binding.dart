import 'package:get/get.dart';

import '../controllers/hrd_surat_tugas_controller.dart';

class HrdSuratTugasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HrdSuratTugasController>(
      () => HrdSuratTugasController(),
    );
  }
}
