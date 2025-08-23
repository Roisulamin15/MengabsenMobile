import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class EditProfilView extends StatefulWidget {
  const EditProfilView({super.key});

  @override
  State<EditProfilView> createState() => _EditProfilViewState();
}

class _EditProfilViewState extends State<EditProfilView> {
  final namaController = TextEditingController();
  final hpController = TextEditingController();
  final emailController = TextEditingController();
  final tglLahirController = TextEditingController();
  final ktpController = TextEditingController();
  final pasporController = TextEditingController();
  final alamatController = TextEditingController();

  String? jenisKelamin;
  String? provinsi;
  String? kabupaten;
  String? kecamatan;
  String? kota;

  void showResultDialog({
    required bool isSuccess,
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSuccess ? Colors.orange : Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: isSuccess ? Colors.green : Colors.red,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("OK"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
            // Card profil + SVG
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("assets/izul.jpg"),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Halo, Muhammad Roisul Amin",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Jakarta, Indonesia",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
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
            ),
            const SizedBox(height: 20),

            // Form fields
            buildTextField("Nama Lengkap", "Nama sesuai identitas", namaController),
            buildTextField("Nomor HP", "62 XXX XXX XXX", hpController,
                keyboardType: TextInputType.phone),
            buildTextField("Alamat Email", "isi dengan alamat email aktifmu",
                emailController,
                keyboardType: TextInputType.emailAddress),
            buildTextField("Tanggal Lahir",
                "tanggal/bulan/tahun contoh 01/01/2000", tglLahirController,
                suffixIcon: Icons.calendar_today),
            buildDropdown("Jenis Kelamin",
                ["Laki-laki", "Perempuan", "Lainnya"], jenisKelamin, (val) {
              setState(() => jenisKelamin = val);
            }),
            buildTextField("Nomor e-KTP/SIM (Opsional)",
                "16 digit nomor KTP/17 digit nomor SIM", ktpController),
            buildTextField("Nomor ID Paspor (Opsional)",
                "7 digit nomor paspor", pasporController),
            buildDropdown("Provinsi (Opsional)",
                ["Jawa Tengah", "Jawa Barat", "DKI Jakarta"], provinsi, (val) {
              setState(() => provinsi = val);
            }),
            buildDropdown("Kabupaten (Opsional)",
                ["Kabupaten 1", "Kabupaten 2"], kabupaten, (val) {
              setState(() => kabupaten = val);
            }),
            buildDropdown("Kecamatan (Opsional)",
                ["Kecamatan 1", "Kecamatan 2"], kecamatan, (val) {
              setState(() => kecamatan = val);
            }),
            buildDropdown("Kota (Opsional)", ["Kota 1", "Kota 2"], kota, (val) {
              setState(() => kota = val);
            }),
            buildTextField("Alamat (Opsional)", "Isi alamat lengkapmu",
                alamatController,
                maxLines: 3),

            const SizedBox(height: 20),

            // Tombol simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (namaController.text.isNotEmpty) {
                    showResultDialog(
                      isSuccess: true,
                      title: "Data Berhasil Disimpan",
                      message:
                          "Perubahan berhasil disimpan\nSilahkan menunggu konfirmasi dari admin.",
                    );
                  } else {
                    showResultDialog(
                      isSuccess: false,
                      title: "Terjadi Kesalahan",
                      message: "Coba lagi nanti",
                    );
                  }
                },
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
      String label, String hint, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
      IconData? suffixIcon,
      int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
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
        value: value,
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
