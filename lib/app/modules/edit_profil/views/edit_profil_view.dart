import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/edit_profil_controller.dart';

class EditProfilView extends GetView<EditProfilController> {
  const EditProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profil"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header profil
            Obx(() => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Color.fromARGB(249, 183, 181, 181),
                        child: Icon(Icons.person, color: Colors.white, size: 35),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Halo, ${controller.username.value}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              controller.role.value,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 20),

            // Input field
            buildTextField("Nama Lengkap", "Nama sesuai identitas", controller.namaController),
            buildTextField("Email", "Email aktifmu", controller.emailController,
                keyboardType: TextInputType.emailAddress),
            buildTextField("Nomor HP", "62 XXX XXX XXX", controller.hpController,
                keyboardType: TextInputType.phone),
            buildDateField(context, "Tanggal Lahir", controller.tglLahirController),
            buildDropdown(
              "Jenis Kelamin",
              ["Laki-laki", "Perempuan", "Lainnya"],
              controller.jenisKelamin.value,
              (val) => controller.jenisKelamin.value = val,
            ),

            buildTextField(
              "Nomor e-KTP/SIM (Opsional)",
              "16 digit nomor KTP",
              controller.ktpController,
              keyboardType: TextInputType.number,
              maxLength: 16,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            buildTextField(
              "Nomor ID Paspor (Opsional)",
              "7 digit nomor paspor",
              controller.pasporController,
              keyboardType: TextInputType.number,
              maxLength: 7,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),

            buildDropdown("Kelurahan (Opsional)", ["Kelurahan 1", "Kelurahan 2"],
                controller.kelurahan.value, (val) => controller.kelurahan.value = val),
            buildDropdown("Kecamatan (Opsional)", ["Kecamatan 1", "Kecamatan 2"],
                controller.kecamatan.value, (val) => controller.kecamatan.value = val),
            buildDropdown("Kota (Opsional)", ["Kota 1", "Kota 2"],
                controller.kota.value, (val) => controller.kota.value = val),
            buildDropdown(
                "Provinsi (Opsional)",
                ["Jawa Tengah", "Jawa Barat", "DKI Jakarta"],
                controller.provinsi.value,
                (val) => controller.provinsi.value = val),
            buildTextField("Alamat (Opsional)", "Isi alamat lengkapmu", controller.alamatController,
                maxLines: 3),

            const SizedBox(height: 20),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.simpanData(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Simpan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    String hint,
    TextEditingController c, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: c,
        keyboardType: keyboardType,
        maxLines: maxLines,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          counterText: "",
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget buildDateField(BuildContext context, String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: c,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          hintText: "Pilih tanggal",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: const Icon(Icons.calendar_today, size: 20),
        ),
        onTap: () async {
          FocusScope.of(context).unfocus();
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.tryParse(c.text) ?? DateTime(2000, 1, 1),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            c.text =
                "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
          }
        },
      ),
    );
  }

  Widget buildDropdown(
      String label, List<String> items, String? value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value?.isEmpty == true ? null : value,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
