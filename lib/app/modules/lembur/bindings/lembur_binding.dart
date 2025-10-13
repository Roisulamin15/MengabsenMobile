import 'package:flutter_application_mengabsen/app/modules/detail_lembur/controllers/detail_lembur_controller.dart';
import 'package:flutter_application_mengabsen/app/modules/form_lembur/controllers/form_lembur_controller.dart';
import 'package:get/get.dart';
import '../controllers/lembur_controller.dart';


class LemburBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LemburController>(() => LemburController());
    Get.lazyPut<LemburFormController>(() => LemburFormController());
    Get.lazyPut<DetailLemburController>(() => DetailLemburController());
  }
}
