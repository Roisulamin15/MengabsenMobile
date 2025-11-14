import 'package:get/get.dart';
import '../controllers/hrd_lembur_controller.dart';

class HrdLemburBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HrdLemburController>(() => HrdLemburController());
  }
}
