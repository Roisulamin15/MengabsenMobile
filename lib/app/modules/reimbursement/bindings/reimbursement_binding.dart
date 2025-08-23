import 'package:get/get.dart';
import '../controllers/reimbursement_controller.dart';

class ReimbursementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReimbursementController>(() => ReimbursementController());
  }
}
