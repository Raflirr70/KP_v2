import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Pengeluaran {
  String id;
  String idCabang;
  String namaPengeluaran;
  int jumlahUnit;
  String jenisSatuan;
  int totalHarga;

  Pengeluaran(
    this.id,
    this.idCabang,
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
      map["nama_pengeluaran"] ?? "",
      jn is int ? jn : int.tryParse(jn.toString()) ?? 0,
      map["jenis_satuan"] ?? "",
      th is int ? th : int.tryParse(th.toString()) ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id_cabang": idCabang,
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

  void tambah(Pengeluaran x) {
    _datas.add(x);
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
}
