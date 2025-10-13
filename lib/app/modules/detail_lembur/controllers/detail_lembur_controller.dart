import 'package:get/get.dart';

class DetailLemburController extends GetxController {
  late Map<String, dynamic> lembur;

  @override
  void onInit() {
    super.onInit();
    lembur = Get.arguments ?? {};
  }
}
