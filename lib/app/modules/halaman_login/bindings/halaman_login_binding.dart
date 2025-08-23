import 'package:get/get.dart';

import '../controllers/halaman_login_controller.dart';

class HalamanLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HalamanLoginController>(
      () => HalamanLoginController(),
    );
  }
}
