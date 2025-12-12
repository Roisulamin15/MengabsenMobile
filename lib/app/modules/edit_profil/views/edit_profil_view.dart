import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            Obx(
              () => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 35, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Halo, ${controller.username.value}",
                            style: const TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Text(
                            controller.role.value,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            buildTextField("Nama Lengkap", "Nama sesuai identitas", controller.namaController),
            buildTextField("Email", "Email aktif", controller.emailController),
            buildTextField("Nomor HP", "08xx", controller.hpController),

            buildDateField(context, "Tanggal Lahir", controller.tglLahirController),

            buildDropdown(
              label: "Jenis Kelamin",
              items: ["Laki-laki", "Perempuan", "Lainnya"],
              selectedValue: controller.jenisKelamin.value,
              onChanged: (v) => controller.jenisKelamin.value = v,
            ),

            buildTextField(
              "Nomor e-KTP (Opsional)",
              "16 digit",
              controller.ktpController,
              keyboardType: TextInputType.number,
              maxLength: 16,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),

            buildTextField(
              "Nomor Paspor (Opsional)",
              "7 digit",
              controller.pasporController,
              keyboardType: TextInputType.number,
              maxLength: 7,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),

            buildDropdown(
              label: "Kelurahan (Opsional)",
              items: ["Kelurahan 1", "Kelurahan 2"],
              selectedValue: controller.kelurahan.value,
              onChanged: (v) => controller.kelurahan.value = v,
            ),

            buildDropdown(
              label: "Kecamatan (Opsional)",
              items: ["Kecamatan 1", "Kecamatan 2"],
              selectedValue: controller.kecamatan.value,
              onChanged: (v) => controller.kecamatan.value = v,
            ),

            buildDropdown(
              label: "Kota (Opsional)",
              items: ["Kota 1", "Kota 2"],
              selectedValue: controller.kota.value,
              onChanged: (v) => controller.kota.value = v,
            ),

            buildDropdown(
              label: "Provinsi (Opsional)",
              items: ["DKI Jakarta", "Jawa Barat", "Jawa Tengah"],
              selectedValue: controller.provinsi.value,
              onChanged: (v) => controller.provinsi.value = v,
            ),

            buildTextField("Alamat", "Alamat lengkap", controller.alamatController, maxLines: 3),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.simpanData(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Simpan", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------
  // UI COMPONENTS
  // ---------------------------

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
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        onTap: () async {
          FocusScope.of(context).unfocus();
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime.tryParse(c.text) ?? DateTime(2000),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            c.text =
                "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
          }
        },
      ),
    );
  }

  Widget buildDropdown({
    required String label,
    required List<String> items,
    required String? selectedValue,
    required Function(String?) onChanged,
  }) {
    final safeValue = items.contains(selectedValue) ? selectedValue : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: safeValue,
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
