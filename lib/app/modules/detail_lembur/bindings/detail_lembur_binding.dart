import 'package:get/get.dart';

import '../controllers/detail_lembur_controller.dart';

class DetailLemburBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailLemburController>(
      () => DetailLemburController(),
    );
  }
}
