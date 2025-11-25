import 'package:get/get.dart';

import '../controllers/hrd_detail_surat_tugas_controller.dart';

class HrdDetailSuratTugasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HrdDetailSuratTugasController>(
      () => HrdDetailSuratTugasController(),
    );
  }
}
