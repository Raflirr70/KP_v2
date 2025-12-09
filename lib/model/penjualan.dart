import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailPenjualan {
  String id;
  String namaMakanan;
  int jumlah;
  int totalHarga;

  DetailPenjualan({
    required this.id,
    required this.namaMakanan,
    required this.jumlah,
    required this.totalHarga,
  });

  factory DetailPenjualan.fromMap(String id, Map<String, dynamic> map) {
    return DetailPenjualan(
      id: id,
      namaMakanan: map['nama_makanan'] ?? '',
      jumlah: map['jumlah'] ?? 0,
      totalHarga: map['total_harga'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama_makanan': namaMakanan,
      'jumlah': jumlah,
      'total_harga': totalHarga,
    };
  }
}

class Penjualan {
  String id;
  List<DetailPenjualan> detail;
  int totalHarga;
  TimeOfDay jam;

  Penjualan({
    required this.id,
    required this.detail,
    required this.totalHarga,
    required this.jam,
  });

  String jamToString(TimeOfDay t) => "${t.hour}:${t.minute}";

  static TimeOfDay parseJam(String s) {
    final parts = s.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  factory Penjualan.fromMap(String id, Map<String, dynamic> map) {
    return Penjualan(
      id: id,
      detail: [],
      totalHarga: map['total_harga'] ?? 0,
      jam: parseJam(map['jam'] ?? "00:00"),
    );
  }

  Map<String, dynamic> toMap() {
    return {"total_harga": totalHarga, "jam": jamToString(jam)};
  }
}

class Penjualans extends ChangeNotifier {
  final List<Penjualan> _datas = [];
  bool isLoading = false;

  List<Penjualan> get datas => _datas;

  // ===============================
  // 🔥 FUNGSI SUMMARY
  // ===============================

  /// Total Pendapatan Semua Penjualan
  int Pendapatan() => _datas.fold(0, (sum, p) => sum + p.totalHarga);

  /// Total Porsi semua detail penjualan
  int TotalPorsi() {
    int jumlah = 0;
    for (var p in _datas) {
      for (var d in p.detail) jumlah += d.jumlah;
    }
    return jumlah;
  }

  // ===============================
  // 🔥 AMBIL DATA FIRESTORE
  // ===============================

  Future<void> getPenjualan() async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('penjualan')
          .orderBy('jam')
          .get();

      _datas.clear();

      for (var doc in snapshot.docs) {
        Penjualan p = Penjualan.fromMap(doc.id, doc.data());
        p.detail = await _getDetailPenjualan(doc.id);
        _datas.add(p);
      }
    } catch (e) {
      print("Error getPenjualan: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getPenjualanByIdCabang(String id_cabang) async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('penjualan')
          .where('id_cabang', isEqualTo: id_cabang)
          .orderBy('jam')
          .get();

      _datas.clear();

      for (var doc in snapshot.docs) {
        Penjualan p = Penjualan.fromMap(doc.id, doc.data());
        p.detail = await _getDetailPenjualan(doc.id);
        _datas.add(p);
      }
    } catch (e) {
      print("Error getPenjualanByIdCabang: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // Detail dari subcollection
  Future<List<DetailPenjualan>> _getDetailPenjualan(String idPenjualan) async {
    List<DetailPenjualan> details = [];

    final detailSnap = await FirebaseFirestore.instance
        .collection('penjualan')
        .doc(idPenjualan)
        .collection('detail')
        .get();

    for (var doc in detailSnap.docs) {
      details.add(DetailPenjualan.fromMap(doc.id, doc.data()));
    }

    return details;
  }

  // ===============================
  // 🔥 TAMBAH PENJUALAN
  // ===============================
  Future<void> tambahPenjualan(Penjualan p) async {
    final doc = FirebaseFirestore.instance.collection('penjualan').doc();

    await doc.set(p.toMap());

    for (var d in p.detail) {
      final detailDoc = doc.collection('detail').doc();
      d.id = detailDoc.id;
      await detailDoc.set(d.toMap());
    }

    p.id = doc.id;
    _datas.add(p);
    notifyListeners();
  }

  // ===============================
  // 🔥 HAPUS PENJUALAN
  // ===============================
  Future<void> hapusPenjualan(Penjualan p) async {
    try {
      final detailSnap = await FirebaseFirestore.instance
          .collection('penjualan')
          .doc(p.id)
          .collection('detail')
          .get();

      for (var doc in detailSnap.docs) {
        await doc.reference.delete();
      }

      await FirebaseFirestore.instance
          .collection('penjualan')
          .doc(p.id)
          .delete();

      _datas.removeWhere((x) => x.id == p.id);
      notifyListeners();
    } catch (e) {
      print("Error hapusPenjualan: $e");
    }
  }
}
