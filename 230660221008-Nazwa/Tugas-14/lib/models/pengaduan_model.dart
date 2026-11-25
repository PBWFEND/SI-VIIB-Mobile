import 'package:flutter/material.dart';

enum StatusPengajuan {
  menunggu('Menunggu'),
  diproses('Diproses'),
  selesai('Selesai');

  const StatusPengajuan(this.label);

  final String label;

  IconData get ikon {
    switch (this) {
      case StatusPengajuan.menunggu:
        return Icons.schedule;
      case StatusPengajuan.diproses:
        return Icons.build_circle_outlined;
      case StatusPengajuan.selesai:
        return Icons.check_circle_outline;
    }
  }

  Color warnaLatar(ColorScheme scheme) {
    switch (this) {
      case StatusPengajuan.menunggu:
        return scheme.tertiaryContainer;
      case StatusPengajuan.diproses:
        return scheme.secondaryContainer;
      case StatusPengajuan.selesai:
        return scheme.primaryContainer;
    }
  }

  Color warnaTeks(ColorScheme scheme) {
    switch (this) {
      case StatusPengajuan.menunggu:
        return scheme.onTertiaryContainer;
      case StatusPengajuan.diproses:
        return scheme.onSecondaryContainer;
      case StatusPengajuan.selesai:
        return scheme.onPrimaryContainer;
    }
  }
}

class Pengaduan {
  const Pengaduan({
    required this.id,
    required this.nim,
    required this.email,
    required this.lokasi,
    required this.tanggalKejadian,
    required this.deskripsi,
    required this.status,
    this.namaLampiran,
  });

  final String id;
  final String nim;
  final String email;
  final String lokasi;
  final String tanggalKejadian;
  final String deskripsi;
  final StatusPengajuan status;
  final String? namaLampiran;

  Pengaduan copyWith({
    String? id,
    String? nim,
    String? email,
    String? lokasi,
    String? tanggalKejadian,
    String? deskripsi,
    StatusPengajuan? status,
    String? namaLampiran,
  }) {
    return Pengaduan(
      id: id ?? this.id,
      nim: nim ?? this.nim,
      email: email ?? this.email,
      lokasi: lokasi ?? this.lokasi,
      tanggalKejadian: tanggalKejadian ?? this.tanggalKejadian,
      deskripsi: deskripsi ?? this.deskripsi,
      status: status ?? this.status,
      namaLampiran: namaLampiran ?? this.namaLampiran,
    );
  }
}
