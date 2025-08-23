import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reimbursement_controller.dart';

class ReimbursementView extends GetView<ReimbursementController> {
  const ReimbursementView({super.key});

  Color getStatusColor(String status) {
    switch (status) {
      case "Disetujui":
        return Colors.green;
      case "Ditolak":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reimbursement",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "List Reimbursement",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // ================= FILTER =================
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Obx(
                    () => DropdownButton<String>(
                      isExpanded: true,
                      underline: const SizedBox(),
                      value: controller.selectedStatus.value,
                      items: [
                        "Semua",
                        "Menunggu Persetujuan",
                        "Disetujui",
                        "Ditolak"
                      ]
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          controller.selectedStatus.value = value!,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Obx(
                    () => DropdownButton<String>(
                      isExpanded: true,
                      underline: const SizedBox(),
                      value: controller.selectedMonth.value,
                      items: controller.months
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          controller.selectedMonth.value = value!,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Obx(
                    () => DropdownButton<String>(
                      isExpanded: true,
                      underline: const SizedBox(),
                      value: controller.selectedYear.value,
                      items: ["2023", "2024", "2025"]
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          controller.selectedYear.value = value!,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ================= LIST DATA =================
            Expanded(
              child: Obx(() {
                final data = controller.filteredList;
                if (data.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.inbox, size: 56, color: Colors.grey),
                        SizedBox(height: 8),
                        Text("Tidak ada data",
                            style:
                                TextStyle(fontSize: 16, color: Colors.grey)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    final statusColor = getStatusColor(item["status"]);
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item["title"] ?? '-',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                                Text(
                                  item["date"] ?? '-',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: statusColor),
                              ),
                              child: Text(
                                (item["status"] ?? '-').toUpperCase(),
                                style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            // ================= BUTTON AJUKAN =================
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: controller.goToForm,
                child: const Text(
                  "Ajukan",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
