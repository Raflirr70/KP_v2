import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'stock.dart'; // pastikan Stock sudah diperbaiki seperti sebelumnya

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Makanan {
  String id;
  String nama;
  int harga;

  Makanan({required this.id, required this.nama, required this.harga});

  // Convert dari Firestore
  factory Makanan.fromMap(String id, Map<String, dynamic> map) {
    final hargaField = map['harga'];
    return Makanan(
      id: id,
      nama: map['nama'] ?? '',
      harga: hargaField is int
          ? hargaField
          : int.tryParse(hargaField.toString()) ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {"nama": nama, "harga": harga};
  }
}

class Makanans extends ChangeNotifier {
  final List<Makanan> _datas = [];
  bool isLoading = true;

  List<Makanan> get datas => _datas;

  Stream<List<Makanan>> streamMakanan() {
    return FirebaseFirestore.instance.collection('makanan').snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((doc) => Makanan.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> tambahMakanan(Makanan makanan) async {
    final doc = FirebaseFirestore.instance.collection("makanan").doc();
    await doc.set(makanan.toMap());

    // Simpan ID dokumen
    makanan.id = doc.id;
    _datas.add(makanan);
    notifyListeners();
  }

  Future<List<Makanan>> getMakanan() async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('makanan')
          .get();

      _datas.clear();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        _datas.add(Makanan.fromMap(doc.id, data));
      }
    } catch (e) {
      print("Error getMakanan: $e");
    }

    isLoading = false;
    notifyListeners();

    return _datas; // ← WAJIB RETURN
  }

  Future<Makanan?> getMakananById(String id_makanan) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('makanan')
          .where("id", isEqualTo: id_makanan)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final doc = snapshot.docs.first;
      return Makanan.fromMap(doc.id, doc.data());
    } catch (e) {
      print("Error getMakananById: $e");
      return null;
    }
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
