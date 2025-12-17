import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailPenjualan {
  String id;
  String id_makanan;
  int jumlah;
  int totalHarga;

  DetailPenjualan({
    required this.id,
    required this.id_makanan,
    required this.jumlah,
    required this.totalHarga,
  });

  factory DetailPenjualan.fromMap(String id, Map<String, dynamic> map) {
    return DetailPenjualan(
      id: id,
      id_makanan: map['id_makanan'] ?? '',
      jumlah: map['jumlah'] ?? 0,
      totalHarga: map['total_harga'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_makanan': id_makanan,
      'jumlah': jumlah,
      'total_harga': totalHarga,
    };
  }
}

class Penjualan {
  String id;
  String id_cabang;
  String id_laporan;
  List<DetailPenjualan> detail;
  int totalHarga;
  TimeOfDay jam;

  Penjualan({
    required this.id,
    required this.id_cabang,
    required this.id_laporan,
    required this.detail,
    required this.totalHarga,
    required this.jam,
  });

  String jamToString(TimeOfDay t) =>
      "${t.hour}:${t.minute.toString().padLeft(2, '0')}";

  static TimeOfDay parseJam(String s) {
    final parts = s.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  factory Penjualan.fromMap(String id, Map<String, dynamic> map) {
    return Penjualan(
      id: id,
      id_cabang: map['id_cabang'],
      id_laporan: map['id_laporan'],
      detail: [],
      totalHarga: map['total_harga'] ?? 0,
      jam: parseJam(map['jam'] ?? "00:00"),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id_cabang": id_cabang,
      "id_laporan": id_laporan,
      "total_harga": totalHarga,
      "jam": jamToString(jam),
    };
  }
}

class Penjualans extends ChangeNotifier {
  final List<Penjualan> _datas = [];
  bool isLoading = false;

  List<Penjualan> get datas => _datas;

  // ===============================
  // 🔥 SUMMARY
  // ===============================

  int Pendapatan() => _datas.fold(0, (sum, p) => sum + p.totalHarga);

  int TotalPorsi() {
    int jumlah = 0;
    for (var p in _datas) {
      for (var d in p.detail) {
        jumlah += d.jumlah;
      }
    }
    return jumlah;
  }

  // ===============================
  // 🔥 GET DATA
  // ===============================
  Stream<List<Penjualan>> streamPenjualanByIdCabang(String idCabang) {
    final penjualanRef = FirebaseFirestore.instance
        .collection('penjualan')
        .where('id_cabang', isEqualTo: idCabang);

    return penjualanRef.snapshots().asyncMap((snapshot) async {
      List<Penjualan> result = [];

      for (var doc in snapshot.docs) {
        Penjualan p = Penjualan.fromMap(doc.id, doc.data());

        // Ambil detail secara async
        final detailSnap = await doc.reference.collection('detail').get();
        p.detail = detailSnap.docs
            .map((d) => DetailPenjualan.fromMap(d.id, d.data()))
            .toList();

        result.add(p);
      }

      return result;
    });
  }

  Stream<List<Penjualan>> streamPenjualanByIdLaporan(String idLaporan) {
    final penjualanRef = FirebaseFirestore.instance
        .collection('penjualan')
        .where('id_laporan', isEqualTo: idLaporan);

    return penjualanRef.snapshots().asyncMap((snapshot) async {
      List<Penjualan> result = [];

      for (var doc in snapshot.docs) {
        Penjualan p = Penjualan.fromMap(doc.id, doc.data());

        // Ambil detail secara async
        final detailSnap = await doc.reference.collection('detail').get();
        p.detail = detailSnap.docs
            .map((d) => DetailPenjualan.fromMap(d.id, d.data()))
            .toList();

        result.add(p);
      }

      return result;
    });
  }

  Future<void> getPenjualan() async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('penjualan')
          .orderBy('jam', descending: true)
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

  Future<void> getPenjualanByIdLaporan(String idLaporan) async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('penjualan')
          .where('id_laporan', isEqualTo: idLaporan)
          // .orderBy('jam')
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

  Future<void> getPenjualanByIdCabang(String idCabang) async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('penjualan')
          .where('id_cabang', isEqualTo: idCabang)
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
  // 🔥 HAPUS
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
