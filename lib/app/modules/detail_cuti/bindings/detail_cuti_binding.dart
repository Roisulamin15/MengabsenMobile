import 'package:get/get.dart';

import '../controllers/detail_cuti_controller.dart';

class DetailCutiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailCutiController>(
      () => DetailCutiController(),
    );
  }
}
