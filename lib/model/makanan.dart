import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kerprak/model/stock.dart';

class Makanan {
  String id; // ID dokumen Firestore
  String nama;
  int harga;
  List<Stock> stocks;

  Makanan({
    required this.id,
    required this.nama,
    required this.harga,
    required this.stocks,
  });

  // Convert dari Firestore
  factory Makanan.fromMap(
    String id,
    Map<String, dynamic> map,
    List<Stock> stocks,
  ) {
    return Makanan(
      id: id,
      nama: map['nama'],
      harga: map['harga'],
      stocks: stocks,
    );
  }

  // Convert ke Firestore
  Map<String, dynamic> toMap() {
    return {"nama": nama, "harga": harga};
  }
}

class Makanans extends ChangeNotifier {
  final List<Makanan> _datas = [];
  bool isLoading = true;

  List<Makanan> get datas => _datas;

  Future<void> tambahMakanan(Makanan makanan) async {
    final doc = FirebaseFirestore.instance.collection("makanan").doc();

    await doc.set(makanan.toMap());

    // Tambahkan id setelah disimpan
    makanan.id = doc.id;
    _datas.add(makanan);
    notifyListeners();
  }

  Future<void> getMakanan() async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('makanan')
          .get();

      _datas.clear();

      for (var doc in snapshot.docs) {
        final data = doc.data();

        // --- Ambil subcollection stock ---
        final stockSnap = await doc.reference.collection('stock').get();

        List<Stock> stocks = stockSnap.docs.map((s) {
          return Stock.fromMap(s.id, s.data());
        }).toList();

        // --- Tambahkan makanan ke list ---
        _datas.add(
          Makanan(
            id: doc.id, // INI WAJIB doc.id
            nama: data['nama'] ?? '',
            harga: data['harga'] ?? 0,
            stocks: stocks,
          ),
        );
      }
    } catch (e) {
      print("Error getMakanan: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> hapusMakanan(Makanan makanan) async {
    try {
      await FirebaseFirestore.instance
          .collection('makanan')
          .doc(makanan.id)
          .delete();

      _datas.removeWhere((m) => m.id == makanan.id);
      notifyListeners();
    } catch (e) {
      print("Error hapusMakanan: $e");
    }
  }
}
