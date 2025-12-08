import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Laporan {
  String id; // pakai string supaya aman dengan Firestore auto-id
  String? id_penjualan;
  String? id_pengeluaran;
  int total_pendapatan;
  int total_pengeluaran;
  bool status;
  DateTime? tanggal;
  String? id_cabang; // tambah field cabang

  Laporan({
    required this.id,
    this.id_penjualan,
    this.id_pengeluaran,
    this.total_pendapatan = 0,
    this.total_pengeluaran = 0,
    this.status = false,
    this.tanggal,
    this.id_cabang,
  });

  factory Laporan.fromMap(String docId, Map<String, dynamic> map) {
    return Laporan(
      id: docId,
      id_penjualan: map['id_penjualan'],
      id_pengeluaran: map['id_pengeluaran'],
      total_pendapatan: map['total_pendapatan'] ?? 0,
      total_pengeluaran: map['total_pengeluaran'] ?? 0,
      status: map['status'] ?? false,
      tanggal: map['tanggal'] != null
          ? (map['tanggal'] is Timestamp
                ? (map['tanggal'] as Timestamp).toDate()
                : DateTime.parse(map['tanggal']))
          : null,
      id_cabang: map['id_cabang'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_penjualan': id_penjualan,
      'id_pengeluaran': id_pengeluaran,
      'total_pendapatan': total_pendapatan,
      'total_pengeluaran': total_pengeluaran,
      'status': status,
      'tanggal': tanggal != null ? Timestamp.fromDate(tanggal!) : null,
      'id_cabang': id_cabang,
    };
  }
}

class Laporans extends ChangeNotifier {
  final List<Laporan> _datas = [];
  List<Laporan> get datas => _datas;

  /// Ambil semua data laporan untuk cabang tertentu
  Future<void> getData(String id_cabang) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("laporan")
          .where('id_cabang', isEqualTo: id_cabang)
          .get();

      _datas.clear();
      _datas.addAll(
        snapshot.docs
            .map((doc) => Laporan.fromMap(doc.id, doc.data()))
            .toList(),
      );

      notifyListeners();
    } catch (e) {
      print("Error getData Laporan: $e");
    }
  }

  /// Tambah laporan ke list lokal
  void tambah(Laporan x) {
    _datas.add(x);
    notifyListeners();
  }

  /// Hapus laporan berdasarkan ID
  void hapus(String id) {
    _datas.removeWhere((l) => l.id == id);
    notifyListeners();
  }

  /// Total pendapatan semua laporan
  int totalPendapatan() {
    return _datas.fold(0, (sum, l) => sum + l.total_pendapatan);
  }

  /// Total pengeluaran semua laporan
  int totalPengeluaran() {
    return _datas.fold(0, (sum, l) => sum + l.total_pengeluaran);
  }

  /// Cek dan buat laporan hari ini jika belum ada
  Future<void> checkAndCreateLaporan(String id_cabang) async {
    final today = DateTime.now();

    // cek apakah sudah ada laporan hari ini untuk cabang ini
    final existingLaporan = _datas.any(
      (l) =>
          l.id_cabang == id_cabang &&
          l.tanggal != null &&
          l.tanggal!.year == today.year &&
          l.tanggal!.month == today.month &&
          l.tanggal!.day == today.day,
    );

    print(existingLaporan);
    if (!existingLaporan) {
      final newLaporanRef = FirebaseFirestore.instance
          .collection("laporan")
          .doc();
      final newLaporan = Laporan(
        id: newLaporanRef.id,
        total_pendapatan: 0,
        total_pengeluaran: 0,
        status: false,
        tanggal: today,
        id_cabang: id_cabang,
      );

      // simpan ke Firestore
      await newLaporanRef.set(newLaporan.toMap());

      // simpan ke list lokal
      tambah(newLaporan);
    }
  }
}
