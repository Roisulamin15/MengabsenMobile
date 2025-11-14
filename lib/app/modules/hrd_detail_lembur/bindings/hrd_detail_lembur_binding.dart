import 'package:get/get.dart';

import '../controllers/hrd_detail_lembur_controller.dart';

class HrdDetailLemburBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HrdDetailLemburController>(
      () => HrdDetailLemburController(),
    );
  }
}
