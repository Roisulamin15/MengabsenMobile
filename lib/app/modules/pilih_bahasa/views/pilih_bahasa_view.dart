import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pilih_bahasa_controller.dart';

class PilihBahasaView extends GetView<PilihBahasaController> {
  const PilihBahasaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pilih Bahasa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        return Column(
          children: [
            _buildLanguageOption(
              title: 'Bahasa Indonesia',
              value: 'id',
              groupValue: controller.selectedLanguage.value,
              onChanged: (val) => controller.setLanguage(val!),
            ),
            const Divider(),
            _buildLanguageOption(
              title: 'Bahasa Inggris',
              value: 'en',
              groupValue: controller.selectedLanguage.value,
              onChanged: (val) => controller.setLanguage(val!),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLanguageOption({
    required String title,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      leading: Radio<String>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: Colors.orange,
      ),
      title: Text(title),
      onTap: () => onChanged(value),
    );
  }
}
