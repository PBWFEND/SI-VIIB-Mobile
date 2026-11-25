// Tugas 13: Testing, Debugging, dan Perbaikan — Widget & Unit Test
// Nama  : Reina Anatasya Kusumah Putri
// NIM   : 230660221103
// Kelas : SI-VIIB

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kantin_kampus_testing/main.dart';

void main() {
  group('Unit Test ValidatorPesanan', () {
    test('Menolak nama kosong dan menerima nama valid', () {
      expect(ValidatorPesanan.validasiNama('   '), 'Nama pemesan wajib diisi');
      expect(ValidatorPesanan.validasiNama('Reina Anatasya'), isNull);
    });

    test('Menolak porsi di luar rentang 1..50', () {
      expect(
        ValidatorPesanan.validasiPorsi('0'),
        'Jumlah porsi harus antara 1 sampai 50',
      );
      expect(
        ValidatorPesanan.validasiPorsi('60'),
        'Jumlah porsi harus antara 1 sampai 50',
      );
      expect(ValidatorPesanan.validasiPorsi('2'), isNull);
    });
  });

  group('Widget Test HalamanPemesananTeruji', () {
    testWidgets('TC-02: Menampilkan pesan error saat field wajib kosong',
        (tester) async {
      await tester.pumpWidget(const KantinTestingApp());

      expect(find.text('Belum ada pesanan tercatat'), findsOneWidget);

      await tester.tap(find.byKey(const Key('tombol_simpan')));
      await tester.pump();

      expect(find.text('Nama pemesan wajib diisi'), findsOneWidget);
      expect(find.text('Nama menu wajib diisi'), findsOneWidget);
      expect(find.text('Jumlah porsi wajib diisi'), findsOneWidget);
      expect(find.text('Daftar Pesanan (0)'), findsOneWidget);
    });

    testWidgets('TC-01: Menambah pesanan valid dan memperbarui daftar',
        (tester) async {
      await tester.pumpWidget(const KantinTestingApp());

      await tester.enterText(
        find.byKey(const Key('input_nama')),
        'Reina Anatasya',
      );
      await tester.enterText(
        find.byKey(const Key('input_menu')),
        'Nasi Goreng Spesial',
      );
      await tester.enterText(find.byKey(const Key('input_porsi')), '2');

      await tester.tap(find.byKey(const Key('tombol_simpan')));
      await tester.pump();

      // Memastikan tombol berubah menjadi status loading
      expect(find.text('Menyimpan...'), findsOneWidget);

      // Menunggu simulasi async 300ms selesai
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Daftar Pesanan (1)'), findsOneWidget);
      expect(find.text('Nasi Goreng Spesial (2x)'), findsOneWidget);
      expect(find.text('Pemesan: Reina Anatasya'), findsOneWidget);
    });

    testWidgets(
        'TC-04 (Regresi BUG-01): Menekan tombol simpan dua kali cepat hanya membuat 1 pesanan',
        (tester) async {
      await tester.pumpWidget(const KantinTestingApp());

      await tester.enterText(
        find.byKey(const Key('input_nama')),
        'Reina Anatasya',
      );
      await tester.enterText(
        find.byKey(const Key('input_menu')),
        'Ayam Geprek',
      );
      await tester.enterText(find.byKey(const Key('input_porsi')), '1');

      // Ketuk tombol simpan dua kali secara beruntun
      await tester.tap(find.byKey(const Key('tombol_simpan')));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.byKey(const Key('tombol_simpan')));

      await tester.pump(const Duration(milliseconds: 400));

      // Hanya boleh ada 1 item di daftar, bukan 2
      expect(find.text('Daftar Pesanan (1)'), findsOneWidget);
      expect(find.text('Ayam Geprek (1x)'), findsOneWidget);
    });

    testWidgets('TC-05: Menghapus pesanan memperbarui daftar dan kembali ke empty state',
        (tester) async {
      await tester.pumpWidget(const KantinTestingApp());

      await tester.enterText(
        find.byKey(const Key('input_nama')),
        'Reina Anatasya',
      );
      await tester.enterText(
        find.byKey(const Key('input_menu')),
        'Soto Ayam',
      );
      await tester.enterText(find.byKey(const Key('input_porsi')), '1');

      await tester.tap(find.byKey(const Key('tombol_simpan')));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Daftar Pesanan (1)'), findsOneWidget);

      await tester.tap(find.byKey(const Key('hapus_ORD-1')));
      await tester.pump();

      expect(find.text('Daftar Pesanan (0)'), findsOneWidget);
      expect(find.text('Belum ada pesanan tercatat'), findsOneWidget);
    });
  });
}