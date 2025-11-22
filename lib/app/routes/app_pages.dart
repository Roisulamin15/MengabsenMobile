import 'package:flutter_application_mengabsen/app/modules/surat_tugas_detail/views/surat_tugas_detail_view.dart';
import 'package:get/get.dart';

import '../modules/Landing_page/bindings/landing_page_binding.dart';
import '../modules/Landing_page/views/landing_page_view.dart';
import '../modules/alamat_saya/bindings/alamat_saya_binding.dart';
import '../modules/alamat_saya/views/alamat_saya_view.dart';
import '../modules/cuti/bindings/cuti_binding.dart';
import '../modules/cuti/views/cuti_view.dart';
import '../modules/detail_cuti/bindings/detail_cuti_binding.dart';
import '../modules/detail_cuti/views/detail_cuti_view.dart';
import '../modules/detail_lembur/bindings/detail_lembur_binding.dart';
import '../modules/detail_lembur/views/detail_lembur_view.dart';
import '../modules/edit_profil/bindings/edit_profil_binding.dart';
import '../modules/edit_profil/views/edit_profil_view.dart';
import '../modules/form_lembur/bindings/form_lembur_binding.dart';
import '../modules/form_lembur/views/form_lembur_view.dart';
import '../modules/ganti_password/bindings/ganti_password_binding.dart';
import '../modules/ganti_password/views/ganti_password_view.dart';
import '../modules/halaman_login/bindings/halaman_login_binding.dart';
import '../modules/halaman_login/views/halaman_login_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/hrd_cuti/bindings/hrd_cuti_binding.dart';
import '../modules/hrd_cuti/views/hrd_cuti_view.dart';
import '../modules/hrd_detail_cuti/bindings/hrd_detail_cuti_binding.dart';
import '../modules/hrd_detail_cuti/views/hrd_detail_cuti_view.dart';
import '../modules/hrd_detail_lembur/bindings/hrd_detail_lembur_binding.dart';
import '../modules/hrd_detail_lembur/views/hrd_detail_lembur_view.dart';
import '../modules/hrd_lembur/bindings/hrd_lembur_binding.dart';
import '../modules/hrd_lembur/views/hrd_lembur_view.dart';
import '../modules/karyawan_absen/bindings/karyawan_absen_binding.dart';
import '../modules/karyawan_absen/views/karyawan_absen_view.dart';
import '../modules/karyawan_absen_wfa/bindings/karyawan_absen_wfa_binding.dart';
import '../modules/karyawan_absen_wfa/views/karyawan_absen_wfa_view.dart';
import '../modules/karyawan_absen_wfo_wfh/bindings/karyawan_absen_wfo_wfh_binding.dart';
import '../modules/karyawan_absen_wfo_wfh/views/karyawan_absen_wfo_wfh_view.dart';
import '../modules/lembur/bindings/lembur_binding.dart';
import '../modules/lembur/views/lembur_view.dart';
import '../modules/list_cuti/bindings/list_cuti_binding.dart';
import '../modules/list_cuti/views/list_cuti_view.dart';
import '../modules/login_email/bindings/login_email_binding.dart';
import '../modules/login_email/views/login_email_view.dart';
import '../modules/lupa_password/bindings/lupa_password_binding.dart';
import '../modules/lupa_password/views/lupa_password_view.dart';
import '../modules/pilih_bahasa/bindings/pilih_bahasa_binding.dart';
import '../modules/pilih_bahasa/views/pilih_bahasa_view.dart';
import '../modules/profil/bindings/profil_binding.dart';
import '../modules/profil/views/profil_view.dart';
import '../modules/reimbursement/bindings/reimbursement_binding.dart';
import '../modules/reimbursement/views/reimbursement_view.dart';
import '../modules/reimbursement_detail/bindings/reimbursement_detail_binding.dart';
import '../modules/reimbursement_detail/views/reimbursement_detail_view.dart';
import '../modules/reimbursement_detail_input/bindings/reimbursement_detail_input_binding.dart';
import '../modules/reimbursement_detail_input/views/reimbursement_detail_input_view.dart';
import '../modules/reimbursement_form/bindings/reimbursement_form_binding.dart';
import '../modules/reimbursement_form/views/reimbursement_form_view.dart';
import '../modules/reimbursement_type/bindings/reimbursement_type_binding.dart';
import '../modules/reimbursement_type/views/reimbursement_type_view.dart';
import '../modules/riwayat_absen/bindings/riwayat_absen_binding.dart';
import '../modules/riwayat_absen/views/riwayat_absen_view.dart';
import '../modules/surat_tugas/bindings/surat_tugas_binding.dart';
import '../modules/surat_tugas/views/surat_tugas_view.dart';
import '../modules/surat_tugas_detail/bindings/surat_tugas_detail_binding.dart';
import '../modules/surat_tugas_detail/controllers/surat_tugas_detail_controller.dart' hide SuratTugasDetailView;
import '../modules/surat_tugas_form/bindings/surat_tugas_form_binding.dart';
import '../modules/surat_tugas_form/views/surat_tugas_form_view.dart';
import '../modules/ubah_password/bindings/ubah_password_binding.dart';
import '../modules/ubah_password/views/ubah_password_view.dart';
import '../modules/verifikasi_email/bindings/verifikasi_email_binding.dart';
import '../modules/verifikasi_email/views/verifikasi_email_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HALAMAN_LOGIN;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.LANDING_PAGE,
      page: () => const LandingPage(),
      binding: LandingPageBinding(),
    ),
    GetPage(
      name: Routes.HALAMAN_LOGIN,
      page: () => const HalamanLoginView(),
      binding: HalamanLoginBinding(),
    ),
    GetPage(
      name: Routes.LOGIN_EMAIL,
      page: () => const LoginEmailView(),
      binding: LoginEmailBinding(),
    ),
    GetPage(
      name: Routes.LUPA_PASSWORD,
      page: () => const LupaPasswordView(),
      binding: LupaPasswordBinding(),
    ),
    GetPage(
      name: Routes.VERIFIKASI_EMAIL,
      page: () => const VerifikasiEmailView(),
      binding: VerifikasiEmailBinding(),
    ),
    GetPage(
      name: Routes.UBAH_PASSWORD,
      page: () => const UbahPasswordView(),
      binding: UbahPasswordBinding(),
    ),
    GetPage(
      name: _Paths.PROFIL,
      page: () => ProfilView(),
      binding: ProfilBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFIL,
      page: () => const EditProfilView(),
      binding: EditProfilBinding(),
    ),
    GetPage(
      name: Routes.GANTI_PASSWORD,
      page: () => const GantiPasswordView(),
      binding: GantiPasswordBinding(),
    ),
    GetPage(
      name: Routes.PILIH_BAHASA,
      page: () => const PilihBahasaView(),
      binding: PilihBahasaBinding(),
    ),
    GetPage(
      name: Routes.ALAMAT_SAYA,
      page: () => const AlamatSayaView(),
      binding: AlamatSayaBinding(),
    ),
    GetPage(
      name: _Paths.CUTI,
      page: () => CutiView(),
      binding: CutiBinding(),
    ),
    GetPage(
      name: _Paths.LIST_CUTI,
      page: () => ListCutiView(),
      binding: ListCutiBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_CUTI,
      page: () => const DetailCutiView(),
      binding: DetailCutiBinding(),
    ),
    GetPage(
      name: Routes.REIMBURSEMENT,
      page: () => const ReimbursementView(),
      binding: ReimbursementBinding(),
    ),
    GetPage(
      name: Routes.REIMBURSEMENT_FORM,
      page: () => const ReimbursementFormView(),
      binding: ReimbursementFormBinding(),
    ),
    GetPage(
      name: _Paths.REIMBURSEMENT_TYPE,
      page: () => const ReimbursementTypeView(),
      binding: ReimbursementTypeBinding(),
    ),
    GetPage(
      name: _Paths.REIMBURSEMENT_DETAIL_INPUT,
      page: () => const ReimbursementDetailInputView(),
      binding: ReimbursementDetailInputBinding(),
    ),
    GetPage(
      name: Routes.REIMBURSEMENT_DETAIL,
      page: () => ReimbursementDetailView(),
      binding: ReimbursementDetailBinding(),
    ),
    GetPage(
      name: Routes.SURAT_TUGAS,
      page: () => const SuratTugasView(),
      binding: SuratTugasBinding(),
    ),
    GetPage(
      name: Routes.SURAT_TUGAS_FORM,
      page: () => const SuratTugasFormView(),
      binding: SuratTugasFormBinding(),
    ),
    GetPage(
      name: Routes.SURAT_TUGAS_DETAIL,
      page: () => const SuratTugasDetailView(),
      binding: SuratTugasDetailBinding(),
    ),
    GetPage(
      name: Routes.HRD_CUTI,
      page: () => HrdCutiView(),
      binding: HrdCutiBinding(),
    ),
    GetPage(
      name: _Paths.HRD_DETAIL_CUTI,
      page: () => HrdDetailCutiView(cuti: Get.arguments),
      binding: HrdDetailCutiBinding(),
    ),
    GetPage(
      name: _Paths.KARYAWAN_ABSEN,
      page: () => const KaryawanAbsenView(),
      binding: KaryawanAbsenBinding(),
    ),
    GetPage(
      name: _Paths.KARYAWAN_ABSEN_WFO_WFH,
      page: () {
        final jenis = Get.arguments ?? "WFO";
        return KaryawanAbsenWfoWfhView(jenis: jenis);
      },
      binding: KaryawanAbsenWfoWfhBinding(),
    ),
    GetPage(
      name: _Paths.LEMBUR,
      page: () => const LemburView(),
      binding: LemburBinding(),
    ),
    GetPage(
      name: _Paths.FORM_LEMBUR,
      page: () => LemburFormView(),
      binding: FormLemburBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_LEMBUR,
      page: () => DetailLemburView(),
      binding: DetailLemburBinding(),
    ),
    GetPage(
      name: _Paths.KARYAWAN_ABSEN_WFA,
      page: () => const KaryawanAbsenWfaView(),
      binding: KaryawanAbsenBinding(), // pakai controller yang sama
    ),
    GetPage(
      name: _Paths.RIWAYAT_ABSEN,
      page: () => const RiwayatAbsenView(),
      binding: RiwayatAbsenBinding(),
    ),
    GetPage(
      name: _Paths.HRD_LEMBUR,
      page: () => const HrdLemburView(),
      binding: HrdLemburBinding(),
    ),
    GetPage(
      name: _Paths.HRD_DETAIL_LEMBUR,
      page: () =>  HrdDetailLemburView(lembur: Get.arguments,),
      binding: HrdDetailLemburBinding(),
    ),
  ];
}
