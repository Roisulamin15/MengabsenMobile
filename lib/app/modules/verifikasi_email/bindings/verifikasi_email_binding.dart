import 'package:get/get.dart';

import 'package:flutter_application_mengabsen/app/modules/verifikasi_email/controllers/verifikasi_email_controller.dart';

class VerifikasiEmailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifikasiEmailController>(
      () => VerifikasiEmailController(),
    );
  }
}



