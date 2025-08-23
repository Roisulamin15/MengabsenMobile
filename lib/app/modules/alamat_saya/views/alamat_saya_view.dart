import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/alamat_saya_controller.dart';

class AlamatSayaView extends GetView<AlamatSayaController> {
  const AlamatSayaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alamat Saya"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildTextField("Alamat*", controller.alamatController),
                _buildDropdown("Pilih Provinsi*", controller.provinsi, controller.provinsiList),
                _buildDropdown("Pilih Kabupaten*", controller.kabupaten, controller.kabupatenList),
                _buildDropdown("Pilih Kecamatan*", controller.kecamatan, controller.kecamatanList),
                _buildDropdown("Pilih Kelurahan*", controller.kelurahan, controller.kelurahanList),
                _buildTextField("Masukan Kode Pos*", controller.kodePosController),
                _buildDropdown("Status Kepemilikan*", controller.statusKepemilikan, controller.statusList),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: controller.simpanAlamat,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text("Simpan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController textController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          labelText: label,
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, RxString selectedValue, List<String> items) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label,
            border: const UnderlineInputBorder(),
          ),
          value: selectedValue.value.isEmpty ? null : selectedValue.value,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (value) {
            if (value != null) selectedValue.value = value;
          },
        ),
      ),
    );
  }
}
