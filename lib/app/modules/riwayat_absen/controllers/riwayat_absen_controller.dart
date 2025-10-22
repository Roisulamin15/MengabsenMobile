import 'package:get/get.dart';

class RiwayatAbsenController extends GetxController {
  var tabIndex = 1.obs;

  var riwayatList = <Map<String, dynamic>>[
    {
      "tanggal": "Jumat, 6 Agustus 2023",
      "jamMasuk": "08:21",
      "statusIn": "On Time",
      "lokasi": "Kantor Iotanesia",
      "jamKeluar": "17:30",
      "statusOut": "Sudah Absen",
      "durasi": "10 Jam 10 Menit",
    },
    {
      "tanggal": "Kamis, 5 Agustus 2023",
      "jamMasuk": "12:00",
      "statusIn": "Late",
      "lokasi": "Rumah 1",
      "jamKeluar": "00:00",
      "statusOut": "Lupa Absen",
      "durasi": "0 Jam 20 Menit",
    },
    {
      "tanggal": "Selasa, 3 Agustus 2023",
      "jamMasuk": "00:00",
      "statusIn": "Cuti",
      "lokasi": "-",
      "jamKeluar": "00:00",
      "statusOut": "-",
      "durasi": "0 Jam",
    },
    {
      "tanggal": "Rabu, 4 Agustus 2023",
      "jamMasuk": "00:00",
      "statusIn": "Sakit",
      "lokasi": "-",
      "jamKeluar": "00:00",
      "statusOut": "-",
      "durasi": "0 Jam",
    },
  ].obs;
}
