import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kerprak/model/makanan.dart';

class Jadwal {
  String id;
  String id_cabang;
  String id_user;

  Jadwal({required this.id, required this.id_cabang, required this.id_user});

  factory Jadwal.fromMap(String id, Map<String, dynamic> map) {
    return Jadwal(id: id, id_cabang: map['nama'], id_user: map['nama']);
  }

  Map<String, dynamic> toMap() {
    return {"id_cabang": id_cabang, "id_user": id_cabang};
  }
}

class Jadwals extends ChangeNotifier {
  final List<Jadwal> _datas = [];
  bool isLoading = true;

  List<Jadwal> get datas => _datas;

  Future<void> getJadwal() async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('jadwal')
          .get();

      _datas.clear();
      _datas.addAll(
        snapshot.docs.map((doc) {
          var data = doc.data();
          return Jadwal(
            id: doc.id ?? '',
            id_cabang: data['id_cabang'] ?? '',
            id_user: data['id_user'],
          );
        }).toList(),
      );
    } catch (e) {
      print("Error getMakanan: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
