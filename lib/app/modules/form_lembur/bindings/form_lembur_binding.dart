import 'package:get/get.dart';

import '../controllers/form_lembur_controller.dart';

class FormLemburBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LemburFormController>(
      () => LemburFormController(),
    );
  }
}
