import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kerprak/model/makanan.dart';

class Jadwal {
  String id;
  String id_cabang;
  String id_user;

  Jadwal({required this.id, required this.id_cabang, required this.id_user});

  factory Jadwal.fromMap(String id, Map<String, dynamic> map) {
    return Jadwal(id: id, id_cabang: map['id_cabang'], id_user: map['id_user']);
  }

  Map<String, dynamic> toMap() {
    return {"id_cabang": id_cabang, "id_user": id_user};
  }
}

class Jadwals extends ChangeNotifier {
  final List<Jadwal> _datas = [];
  bool isLoading = true;

  List<Jadwal> get datas => _datas;

  final _ref = FirebaseFirestore.instance.collection('jadwal');

  Future<void> getJadwal() async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _ref.get();

      _datas.clear();
      _datas.addAll(
        snapshot.docs.map((doc) {
          var data = doc.data();
          return Jadwal(
            id: doc.id,
            id_cabang: data['id_cabang'],
            id_user: data['id_user'],
          );
        }).toList(),
      );
    } catch (e) {
      print("Error getJadwal: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> addJadwal({
    required String idUser,
    required String idCabang,
  }) async {
    try {
      final doc = await _ref.add({"id_user": idUser, "id_cabang": idCabang});

      _datas.add(Jadwal(id: doc.id, id_user: idUser, id_cabang: idCabang));

      notifyListeners();
    } catch (e) {
      print("Error addJadwal: $e");
    }
  }

  Future<void> deleteById(String id) async {
    try {
      await _ref.doc(id).delete();
      _datas.removeWhere((j) => j.id == id);
      notifyListeners();
    } catch (e) {
      print("Error deleteById: $e");
    }
  }

  List<Jadwal> getByCabang(String idCabang) {
    return _datas.where((d) => d.id_cabang == idCabang).toList();
  }

  bool exists(String idUser, String idCabang) {
    return _datas.any((d) => d.id_user == idUser && d.id_cabang == idCabang);
  }
}
