import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reimbursement_type_controller.dart';

class ReimbursementTypeView extends GetView<ReimbursementTypeController> {
  const ReimbursementTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengajuan Reimbursement'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: controller.types.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final t = controller.types[i];

          // Obx cukup di level Card, bukan ListView
          return Obx(() {
            final isSelected = controller.selectedIndex.value == i;

            return InkWell(
              onTap: () => controller.choose(t, i),
              borderRadius: BorderRadius.circular(12),
              splashColor: Colors.orange.withOpacity(0.2),
              highlightColor: Colors.orange.withOpacity(0.1),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: isSelected ? const Color(0xFFDF8546) : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Penggantian $t',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: isSelected ? Colors.white : Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
