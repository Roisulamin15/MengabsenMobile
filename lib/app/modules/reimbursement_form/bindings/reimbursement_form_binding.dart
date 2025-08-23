import 'package:get/get.dart';

import '../controllers/reimbursement_form_controller.dart';

class ReimbursementFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReimbursementFormController>(
      () => ReimbursementFormController(),
    );
  }
}
