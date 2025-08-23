import 'package:get/get.dart';
import '../controllers/list_cuti_controller.dart';

class ListCutiController extends GetxController {
  // Simple dummy storage for list items
  var cutiList = <Map<String, dynamic>>[].obs;

  void tambahCuti(Map<String, dynamic> cuti) {
    cutiList.add(cuti);
  }
}
