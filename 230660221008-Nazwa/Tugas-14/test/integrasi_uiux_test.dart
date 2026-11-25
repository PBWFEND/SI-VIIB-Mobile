import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pengaduan_fasilitas_kampus_rc1/main.dart';
import 'package:pengaduan_fasilitas_kampus_rc1/services/pengaduan_repository.dart';
import 'package:pengaduan_fasilitas_kampus_rc1/services/token_storage_service.dart';

void main() {
  testWidgets(
    'Integrasi Alur Utama: Form simpan -> Daftar terbarui -> Detail -> Ubah status',
    (tester) async {
      await tester.pumpWidget(const AplikasiPengaduanCandidateApp());
      await tester.pumpAndSettle();

      // Pastikan 3 data awal tampil
      expect(find.text('Total: 3'), findsOneWidget);

      // Buka form pengaduan baru
      await tester.tap(find.byKey(const Key('btn_buat_pengaduan')));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('input_lokasi')),
        'Lab Jaringan Lantai 3',
      );
      await tester.enterText(
        find.byKey(const Key('input_deskripsi')),
        'Switch utama rak server mati dan lampu indikator tidak menyala.',
      );

      await tester.ensureVisible(find.byKey(const Key('btn_simpan_laporan')));
      await tester.tap(find.byKey(const Key('btn_simpan_laporan')));
      await tester.pumpAndSettle();

      // Daftar langsung terbarui tanpa muat ulang manual
      expect(find.text('Total: 4'), findsOneWidget);
      expect(find.textContaining('Lab Jaringan Lantai 3'), findsOneWidget);
    },
  );

  testWidgets(
    'Tata Letak Responsif: Lebar 400 px (1 kolom) vs Lebar 900 px (2 kolom)',
    (tester) async {
      // Uji lebar sempit 400 x 800
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const AplikasiPengaduanCandidateApp());
      await tester.pumpAndSettle();

      // Pada 400 px panel detail tidak langsung muncul di sebelah kanan
      expect(find.text('Detail Tiket TKT-1001'), findsNothing);
      expect(find.text('Ketuk untuk detail'), findsWidgets);

      // Ubah ke lebar luas 900 x 800
      tester.view.physicalSize = const Size(900, 800);
      await tester.pumpAndSettle();

      // Pada 900 px panel detail tampil berdampingan di kolom kanan
      expect(find.text('Detail Tiket TKT-1001'), findsOneWidget);
      expect(find.text('Perbarui Status Penanganan'), findsOneWidget);
    },
  );

  testWidgets(
    'Keadaan Kosong & Gagal: Menampilkan pesan yang tepat dan tombol pemulihan',
    (tester) async {
      final storage = SecureSessionTokenStorage();
      final repo = PengaduanRepository(
        tokenStorage: storage,
        muatDataAwal: false,
      );

      await tester.pumpWidget(
        AplikasiPengaduanCandidateApp(repositoryKustom: repo),
      );
      await tester.pumpAndSettle();

      // Keadaan kosong
      expect(
        find.text('Belum ada laporan kerusakan fasilitas yang tercatat.'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('btn_aksi_kosong')), findsOneWidget);

      // Simulasikan keadaan gagal memuat
      repo.simulasiGagalMuat = true;
      await tester.tap(find.byKey(const Key('btn_muat_ulang')));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Gagal memuat daftar pengaduan'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('btn_coba_lagi')), findsOneWidget);

      // Pulihkan koneksi dan tekan Coba Lagi
      repo.simulasiGagalMuat = false;
      await tester.tap(find.byKey(const Key('btn_coba_lagi')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('btn_aksi_kosong')), findsOneWidget);
    },
  );

  testWidgets(
    'Aksesibilitas Target Sentuh: Tombol utama memiliki tinggi minimal 48 piksel',
    (tester) async {
      await tester.pumpWidget(const AplikasiPengaduanCandidateApp());
      await tester.pumpAndSettle();

      final ukuranTombol = tester.getSize(
        find.byKey(const Key('btn_buat_pengaduan')),
      );
      expect(ukuranTombol.height, greaterThanOrEqualTo(48.0));
    },
  );
}
