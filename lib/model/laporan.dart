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

  Future<void> getAllData() async {
    try {
      final now = DateTime.now();

      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      final snapshot = await FirebaseFirestore.instance
          .collection("laporan")
          .where("tanggal", isGreaterThanOrEqualTo: startOfDay)
          .where("tanggal", isLessThan: endOfDay)
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

  Future<double> getPendapatan(String idCabang) async {
    try {
      final now = DateTime.now();

      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      // 1️⃣ Ambil data cabang
      final snapshotCabang = await FirebaseFirestore.instance
          .collection("cabang")
          .doc(idCabang)
          .get();

      if (!snapshotCabang.exists) {
        return 0;
      }

      // 2️⃣ Ambil laporan berdasarkan cabang
      final snapshotLaporan = await FirebaseFirestore.instance
          .collection("laporan")
          .where('id_cabang', isEqualTo: idCabang)
          .where("tanggal", isGreaterThanOrEqualTo: startOfDay)
          .where("tanggal", isLessThan: endOfDay)
          .get();

      double totalPendapatan = 0;

      // 3️⃣ Loop setiap laporan → ambil penjualan
      for (var laporanDoc in snapshotLaporan.docs) {
        final idLaporan = laporanDoc.id;

        final snapshotPenjualan = await FirebaseFirestore.instance
            .collection("penjualan")
            .where('id_laporan', isEqualTo: idLaporan)
            .get();

        for (var penjualan in snapshotPenjualan.docs) {
          totalPendapatan += (penjualan['total_harga'] ?? 0) as int;
        }
      }

      // 4️⃣ Output final
      return totalPendapatan;
    } catch (e) {
      print("Error getPendapatan: $e");
      return 0;
    }
  }

  Future<double> getTotalPendapatan() async {
    try {
      final now = DateTime.now();

      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      // 2️⃣ Ambil laporan berdasarkan cabang
      final snapshotLaporan = await FirebaseFirestore.instance
          .collection("laporan")
          .where("tanggal", isGreaterThanOrEqualTo: startOfDay)
          .where("tanggal", isLessThan: endOfDay)
          .get();

      double totalPendapatan = 0;

      // 3️⃣ Loop setiap laporan → ambil penjualan
      for (var laporanDoc in snapshotLaporan.docs) {
        final idLaporan = laporanDoc.id;

        final snapshotPenjualan = await FirebaseFirestore.instance
            .collection("penjualan")
            .where('id_laporan', isEqualTo: idLaporan)
            .get();

        for (var penjualan in snapshotPenjualan.docs) {
          totalPendapatan += (penjualan['total_harga'] ?? 0) as int;
        }
      }

      // 4️⃣ Output final
      return totalPendapatan;
    } catch (e) {
      print("Error getPendapatan: $e");
      return 0;
    }
  }

  Future<Laporan?> getLaporanHariIni(String id_cabang) async {
    try {
      final now = DateTime.now();

      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await FirebaseFirestore.instance
          .collection("laporan")
          .where("id_cabang", isEqualTo: id_cabang)
          .where("tanggal", isGreaterThanOrEqualTo: startOfDay)
          .where("tanggal", isLessThan: endOfDay)
          .get();

      if (snapshot.docs.isEmpty) {
        return null; // tidak ada laporan hari ini
      }

      final doc = snapshot.docs.first;
      return Laporan.fromMap(doc.id, doc.data());
    } catch (e) {
      print("Error getLaporanHariIni: $e");
      return null;
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

  Future<String> checkAndCreateLaporan(String id_cabang) async {
    // **LOAD DATA DULU**
    await getData(id_cabang);

    final today = DateTime.now();

    final existingLaporan = _datas.where(
      (l) =>
          l.id_cabang == id_cabang &&
          l.tanggal != null &&
          l.tanggal!.year == today.year &&
          l.tanggal!.month == today.month &&
          l.tanggal!.day == today.day,
    );

    if (existingLaporan.isNotEmpty) {
      return existingLaporan.first.id;
    }

    // buat baru
    final newRef = FirebaseFirestore.instance.collection("laporan").doc();

    final newData = Laporan(
      id: newRef.id,
      total_pendapatan: 0,
      total_pengeluaran: 0,
      status: false,
      tanggal: today,
      id_cabang: id_cabang,
    );

    await newRef.set(newData.toMap());
    tambah(newData);

    return newData.id;
  }
}
