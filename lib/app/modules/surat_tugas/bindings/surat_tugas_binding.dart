import 'package:get/get.dart';
import '../controllers/surat_tugas_controller.dart';

class SuratTugasBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SuratTugasController>(
      SuratTugasController(),
      permanent: true,
    );
  }
}
