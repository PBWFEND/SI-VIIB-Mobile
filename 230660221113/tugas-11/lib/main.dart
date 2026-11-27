
import 'package:flutter/material.dart';

import 'halaman_utama.dart';
import 'halaman_integrasi.dart';
import 'halaman_lampiran.dart';

void main() {
  runApp(const FasKampusApp());
}

class FasKampusApp extends StatelessWidget {
  const FasKampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FasKampus',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB21F32),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F7F9),
        useMaterial3: true,
      ),

      // Halaman utama tetap menjadi halaman awal aplikasi.
      home: const HalamanUtama(),

      // Mendaftarkan halaman untuk navigasi.
      routes: {
        '/integrasi': (context) => const HalamanIntegrasi(),
        '/lampiran': (context) => const HalamanLampiran(),
      },
    );
  }
}