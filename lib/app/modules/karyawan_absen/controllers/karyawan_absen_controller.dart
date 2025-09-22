import 'package:get/get.dart';
import 'package:flutter/material.dart';

class KaryawanAbsenController extends GetxController {
  var selectedOption = "".obs;
  var selectedKeterangan = "".obs;
  var deskripsi = TextEditingController();

  var waktu = "12 : 24 : 00".obs;
  var tanggal = "Kamis, 24 / Jan / 2023".obs;
}
