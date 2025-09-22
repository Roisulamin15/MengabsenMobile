import 'package:get/get.dart';
import '../controllers/hrd_cuti_controller.dart';

class HrdCutiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HrdCutiController>(() => HrdCutiController());
  }
}
