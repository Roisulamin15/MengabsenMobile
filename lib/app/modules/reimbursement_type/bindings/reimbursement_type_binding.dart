import 'package:get/get.dart';

import '../controllers/reimbursement_type_controller.dart';

class ReimbursementTypeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReimbursementTypeController>(
      () => ReimbursementTypeController(),
    );
  }
}
