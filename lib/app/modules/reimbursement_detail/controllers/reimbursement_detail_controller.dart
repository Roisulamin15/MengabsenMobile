import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReimbursementDetailController extends GetxController {
  final data = <String, dynamic>{}.obs;

  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  String get totalFormatted => formatter.format(computeTotal());

  num computeTotal() {
    try {
      final items = (data['items'] as List?) ?? const [];
      final total = items.fold<num>(0, (sum, it) {
        final m = (it as Map?) ?? {};
        final raw = m['amount'] ?? m['biaya'] ?? 0;
        if (raw is num) return sum + raw;
        if (raw is String) {
          final v = int.tryParse(raw.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          return sum + v;
        }
        return sum;
      });
      return total;
    } catch (_) {
      return 0;
    }
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      data.assignAll(args.cast<String, dynamic>());
    } else {
      data.clear();
    }
  }
}
