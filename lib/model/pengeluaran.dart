import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Pengeluaran {
  String id;
  String idCabang;
  String id_laporan;
  String namaPengeluaran;
  int jumlahUnit;
  String jenisSatuan;
  int totalHarga;

  Pengeluaran(
    this.id,
    this.idCabang,
    this.id_laporan,
    this.namaPengeluaran,
    this.jumlahUnit,
    this.jenisSatuan,
    this.totalHarga,
  );

  // Convert dari Firestore atau Map
  factory Pengeluaran.fromMap(String id, Map<String, dynamic> map) {
    final jn = map["jumlah_unit"];
    final th = map["total_harga"];
    return Pengeluaran(
      id,
      map["id_cabang"]?.toString() ?? "",
      map["id_laporan"]?.toString() ?? "",
      map["nama_pengeluaran"] ?? "",
      jn is int ? jn : int.tryParse(jn.toString()) ?? 0,
      map["jenis_satuan"] ?? "",
      th is int ? th : int.tryParse(th.toString()) ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id_cabang": idCabang,
      "id_laporan": id_laporan,
      "nama_pengeluaran": namaPengeluaran,
      "jumlah_unit": jumlahUnit,
      "jenis_satuan": jenisSatuan,
      "total_harga": totalHarga,
    };
  }
}

class Pengeluarans extends ChangeNotifier {
  List<Pengeluaran> _datas = [];
  bool isLoading = false;

  List<Pengeluaran> get datas => _datas;

  Stream<List<Pengeluaran>> streamPenjualanByIdLaporan(String idLaporan) {
    final pengeluaranRef = FirebaseFirestore.instance
        .collection('pengeluaran')
        .where('id_laporan', isEqualTo: idLaporan);

    return pengeluaranRef.snapshots().asyncMap((snapshot) async {
      List<Pengeluaran> result = [];

      for (var doc in snapshot.docs) {
        result.add(Pengeluaran.fromMap(doc.id, doc.data()));
      }

      return result;
    });
  }

  int get totalPengeluaranLocal {
    int total = 0;
    for (var item in _datas) {
      total += item.totalHarga;
    }
    return total;
  }

  Future<void> fetchDataLaporan(DateTime time) async {
    isLoading = true;
    notifyListeners();

    try {
      // ===== Tentukan range hari ini =====
      final start = Timestamp.fromDate(
        DateTime(time.year, time.month, time.day),
      );
      final end = Timestamp.fromDate(
        DateTime(time.year, time.month, time.day).add(const Duration(days: 1)),
      );
      print("time $start sampao ke $end");
      print("Apakah masuk ke sini ");

      final lapSnapshot = await FirebaseFirestore.instance
          .collection("laporan")
          .where('tanggal', isGreaterThanOrEqualTo: start)
          .where('tanggal', isLessThan: end)
          .get();

      if (lapSnapshot.docs.isEmpty) {
        print("Tidak ada laporan hari ini");
        _datas = [];
      } else {
        final idLaporan = lapSnapshot.docs.first.id;

        // ===== Ambil pengeluaran berdasarkan laporan ini =====
        final snapshot = await FirebaseFirestore.instance
            .collection('pengeluaran')
            .where('id_laporan', isEqualTo: idLaporan)
            .get();

        _datas = snapshot.docs
            .map((doc) => Pengeluaran.fromMap(doc.id, doc.data()))
            .toList();
      }
    } catch (e) {
      print("Error fetchDataHariIni Pengeluaran: $e");
      _datas = [];
    }

    isLoading = false;
    notifyListeners();
  }

  /// Fetch data dari Firestore
  Future<void> fetchDataHariIni(String idLaporan) async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('pengeluaran')
          .where('id_laporan', isEqualTo: idLaporan)
          .get();

      _datas = snapshot.docs
          .map((doc) => Pengeluaran.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print("Error fetchDataHariIni Pengeluaran: $e");
      _datas = [];
    }

    isLoading = false;
    notifyListeners();
  }

  /// Fetch data dari Firestore
  Future<void> fetchData() async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('pengeluaran')
          .get();

      _datas = snapshot.docs
          .map((doc) => Pengeluaran.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print("Error fetchData Pengeluaran: $e");
      _datas = [];
    }

    isLoading = false;
    notifyListeners();
  }

  /// Tambah data ke Firestore dan list lokal
  Future<void> tambahData(Pengeluaran pengeluaran) async {
    try {
      // Simpan ke Firestore
      final docRef = await FirebaseFirestore.instance
          .collection('pengeluaran')
          .add(pengeluaran.toMap());

      // Update id sesuai Firestore
      pengeluaran.id = docRef.id;

      // Tambahkan ke list lokal
      _datas.add(pengeluaran);
      notifyListeners();
    } catch (e) {
      print("Error tambahData Pengeluaran: $e");
    }
  }

  Future<void> updateData(Pengeluaran pengeluaran) async {
    try {
      await FirebaseFirestore.instance
          .collection('pengeluaran')
          .doc(pengeluaran.id)
          .update(pengeluaran.toMap());

      int index = _datas.indexWhere((p) => p.id == pengeluaran.id);
      if (index != -1) _datas[index] = pengeluaran;
      notifyListeners();
    } catch (e) {
      print("Error updateData Pengeluaran: $e");
    }
  }

  /// Hapus data dari Firestore dan list lokal
  Future<void> hapusData(Pengeluaran pengeluaran) async {
    try {
      await FirebaseFirestore.instance
          .collection('pengeluaran')
          .doc(pengeluaran.id)
          .delete();

      _datas.removeWhere((p) => p.id == pengeluaran.id);
      notifyListeners();
    } catch (e) {
      print("Error hapusData Pengeluaran: $e");
    }
  }
}
