import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HrdDetailCutiController extends GetxController {
  final alasanC = TextEditingController();

  // Data cuti yang dipilih
  var cutiDetail = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void setCutiDetail(Map<String, dynamic> data) {
    cutiDetail.value = data;
    alasanC.text = data["alasan"] ?? "";
  }

  void updateAlasan() {
    cutiDetail["alasan"] = alasanC.text;
    update();
    Get.snackbar("Sukses", "Alasan cuti berhasil diperbarui");
  }

  @override
  void onClose() {
    alasanC.dispose();
    super.onClose();
  }
}
