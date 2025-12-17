import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Cabang {
  String id;
  String nama;

  Cabang({required this.id, required this.nama});

  factory Cabang.fromMap(String id, Map<String, dynamic> map) {
    return Cabang(id: id, nama: map['nama']);
  }

  Map<String, dynamic> toMap() {
    return {"nama": nama};
  }
}

class Cabangs extends ChangeNotifier {
  final List<Cabang> _datas = [];
  bool isLoading = true;

  List<Cabang> get datas => _datas;

  Future<void> getCabang() async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('cabang')
          .get();

      _datas.clear();
      _datas.addAll(
        snapshot.docs.map((doc) {
          var data = doc.data();
          return Cabang(id: doc.id ?? '', nama: data['nama'] ?? '');
        }).toList(),
      );
    } catch (e) {
      print("Error getMakanan: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
