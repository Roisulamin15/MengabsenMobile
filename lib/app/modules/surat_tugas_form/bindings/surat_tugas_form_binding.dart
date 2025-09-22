import 'package:get/get.dart';
import '../controllers/surat_tugas_form_controller.dart';

class SuratTugasFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuratTugasFormController>(() => SuratTugasFormController());
  }
}
