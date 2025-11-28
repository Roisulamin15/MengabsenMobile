import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_application_mengabsen/services/api_service.dart';
import 'package:geolocator/geolocator.dart';

class AbsensiController extends GetxController {
  var selectedOption = "".obs;
  var selectedKeterangan = "".obs;
  TextEditingController deskripsi = TextEditingController();

  var waktu = "".obs;
  var tanggal = "".obs;

  var selfiePath = "".obs;
  final picker = ImagePicker();

  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  final box = GetStorage();
  var karyawanId = 0.obs;
  var roleId = 0.obs;   // 🔥 WAJIB

  @override
  void onInit() {
    super.onInit();
    updateTime();
    getCurrentLocation();
    loadKaryawanId();
    loadRoleId();   // 🔥 WAJIB
  }

  void updateTime() {
    DateTime now = DateTime.now();

    waktu.value =
        "${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}:${now.second.toString().padLeft(2,'0')}";
    tanggal.value =
        "${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}";

    Future.delayed(const Duration(seconds: 1), updateTime);
  }

  Future<void> ambilSelfie() async {
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      maxWidth: 1080,
    );

    if (photo != null) {
      selfiePath.value = photo.path;
      print("📸 Selfie: ${photo.path}");
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latitude.value = pos.latitude;
    longitude.value = pos.longitude;
  }

  // ======================================================
  // LOAD ID KARYAWAN
  // ======================================================
  void loadKaryawanId() {
    final id = box.read("karyawan_id");

    if (id != null) {
      karyawanId.value = int.parse(id.toString());
      print("🔰 Karyawan ID Loaded: ${karyawanId.value}");
    }
  }

  // ======================================================
  // LOAD ROLE ID
  // ======================================================
  void loadRoleId() {
    final rid = box.read("role_id");

    if (rid != null) {
      roleId.value = int.parse(rid.toString());
      print("🔰 Role ID Loaded: ${roleId.value}");
    }
  }

  // ======================================================
  // SUBMIT ABSENSI
  // ======================================================
  Future<void> submitAbsensi() async {
    if (selectedOption.value.isEmpty) {
      Get.snackbar("Gagal", "Pilih jenis absensi!");
      return;
    }

    if (selfiePath.value.isEmpty) {
      Get.snackbar("Gagal", "Harap ambil selfie dulu!");
      return;
    }

    final token = box.read("token");
    if (token == null) {
      Get.snackbar("Error", "Token tidak ditemukan!");
      return;
    }

    if (karyawanId.value == 0) {
      Get.snackbar("Error", "Karyawan ID tidak ditemukan!");
      return;
    }

    if (roleId.value == 0) {
      Get.snackbar("Error", "Role ID tidak ditemukan!");
      return;
    }

    try {    
      // 🔍 DEBUG LOKASI — TARUH DI SINI!!!
      print("📍 Lokasi Terkirim ke Server:");
      print("   → Latitude  : ${latitude.value}");
      print("   → Longitude : ${longitude.value}");

      final response = await ApiService.submitAbsensi(
        jenis: selectedOption.value,
        keterangan: selectedKeterangan.value,
        deskripsi: deskripsi.text,
        tanggal: tanggal.value,
        waktu: waktu.value,
        token: token,
        selfie: File(selfiePath.value),
        karyawanId: karyawanId.value,
        roleId: roleId.value,  // 🔥 PENTING
         latitude: latitude.value,      // 🔥 WAJIB
  longitude: longitude.value,    // 🔥 WAJIB
      );

      print("RESPONSE ABSENSI: $response");

      Get.snackbar("Sukses", response['message'] ?? "Absensi terkirim!");
    } catch (e) {
      print("ERROR ABSENSI: $e");
      Get.snackbar("Error", "Gagal mengirim absensi");
    }
  }
}
