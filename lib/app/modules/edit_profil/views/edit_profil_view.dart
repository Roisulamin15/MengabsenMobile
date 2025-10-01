import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/edit_profil_controller.dart';

class EditProfilView extends GetView<EditProfilController> {
  const EditProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Card profil (ambil username + role + foto)
            Obx(() => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => controller.pilihFoto(),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: controller.fotoProfil.value.isNotEmpty
                              ? FileImage(File(controller.fotoProfil.value))
                              : const AssetImage("assets/izul.jpg")
                                  as ImageProvider,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Halo, ${controller.username.value}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              controller.role.value,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset(
                        'assets/vector.svg',
                        height: 40,
                        width: 40,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 20),

            // 🔹 Form fields
            buildTextField("Nama Lengkap", "Nama sesuai identitas",
                controller.namaController),
            buildTextField("Nomor HP", "62 XXX XXX XXX", controller.hpController,
                keyboardType: TextInputType.phone),
            buildTextField("Alamat Email", "isi dengan alamat email aktifmu",
                controller.emailController,
                keyboardType: TextInputType.emailAddress),
            buildTextField("Tanggal Lahir",
                "tanggal/bulan/tahun contoh 01/01/2000", controller.tglLahirController,
                suffixIcon: Icons.calendar_today),
            buildDropdown("Jenis Kelamin",
                ["Laki-laki", "Perempuan", "Lainnya"],
                controller.jenisKelamin.value, (val) {
              controller.jenisKelamin.value = val;
            }),
            buildTextField("Nomor e-KTP/SIM (Opsional)",
                "16 digit nomor KTP/17 digit nomor SIM", controller.ktpController),
            buildTextField("Nomor ID Paspor (Opsional)",
                "7 digit nomor paspor", controller.pasporController),
            buildDropdown("Provinsi (Opsional)",
                ["Jawa Tengah", "Jawa Barat", "DKI Jakarta"],
                controller.provinsi.value, (val) {
              controller.provinsi.value = val;
            }),
            buildDropdown("Kabupaten (Opsional)",
                ["Kabupaten 1", "Kabupaten 2"],
                controller.kabupaten.value, (val) {
              controller.kabupaten.value = val;
            }),
            buildDropdown("Kecamatan (Opsional)",
                ["Kecamatan 1", "Kecamatan 2"],
                controller.kecamatan.value, (val) {
              controller.kecamatan.value = val;
            }),
            buildDropdown("Kota (Opsional)",
                ["Kota 1", "Kota 2"], controller.kota.value, (val) {
              controller.kota.value = val;
            }),
            buildTextField("Alamat (Opsional)", "Isi alamat lengkapmu",
                controller.alamatController,
                maxLines: 3),

            const SizedBox(height: 20),

            // 🔹 Tombol simpan
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

  Widget buildTextField(String label, String hint, TextEditingController c,
      {TextInputType keyboardType = TextInputType.text,
      IconData? suffixIcon,
      int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: c,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 20) : null,
        ),
      ),
    );
  }

  Widget buildDropdown(
      String label, List<String> items, String? value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value?.isEmpty == true ? null : value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
