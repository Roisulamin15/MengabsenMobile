import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DetailLemburController extends GetxController {
  var namaUser = '-'.obs;
  var lembur = <String, dynamic>{}.obs;
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // Ambil nama user dari storage (hasil login)
    namaUser.value = storage.read("nama_lengkap") ?? "-";

    // Ambil data lembur dari Get.arguments
    lembur.value = Get.arguments ?? {};
  }
}
