import 'package:get/get.dart';

class ListCutiController extends GetxController {
  var cutiList = <Map<String, dynamic>>[].obs;

  void tambahCuti(Map<String, dynamic> data) {
    cutiList.insert(0, data); // biar muncul di atas
  }
}
