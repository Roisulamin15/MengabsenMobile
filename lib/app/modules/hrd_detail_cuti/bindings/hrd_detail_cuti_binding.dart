import 'package:get/get.dart';
import '../controllers/hrd_detail_cuti_controller.dart';

class HrdDetailCutiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HrdDetailCutiController>(
      () => HrdDetailCutiController(),
    );
  }
}
