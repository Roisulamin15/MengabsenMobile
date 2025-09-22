import 'package:get/get.dart';

import '../controllers/surat_tugas_detail_controller.dart';

class SuratTugasDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuratTugasDetailController>(
      () => SuratTugasDetailController(),
    );
  }
}
