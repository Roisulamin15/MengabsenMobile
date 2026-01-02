import 'package:get/get.dart';

import 'package:flutter_application_mengabsen/app/modules/lupa_password/controllers/lupa_password_controller.dart';

class LupaPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LupaPasswordController>(() => LupaPasswordController());
  }
}

