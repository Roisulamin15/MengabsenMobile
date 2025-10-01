import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfilController extends GetxController {
  final box = GetStorage();

  var username = ''.obs;
  var email = ''.obs;

  @override
  void onInit() {
    super.onInit();
    ambilDataUser();
  }

  void ambilDataUser() {
    // Samakan key dengan yang dipakai waktu login
    username.value = box.read('username') ?? 'Pengguna';
    email.value = box.read('email') ?? 'Email belum tersedia';
  }

  void logout() {
    box.erase(); // Hapus semua data user dari penyimpanan
  }
}
