import 'package:get/get.dart';

import '../controllers/reimbursement_detail_input_controller.dart';

class ReimbursementDetailInputBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReimbursementDetailInputController>(
      () => ReimbursementDetailInputController(),
    );
  }
}
