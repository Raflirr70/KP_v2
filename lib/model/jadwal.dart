import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Jadwal {
  String id;
  String id_cabang;
  String id_user;
  int nominal;
  DateTime tanggal;

  Jadwal({
    required this.id,
    required this.id_cabang,
    required this.id_user,
    required this.nominal,
    required this.tanggal,
  });

  /// Convert Firestore → Object
  factory Jadwal.fromMap(String id, Map<String, dynamic> map) {
    return Jadwal(
      id: id,
      id_cabang: map['id_cabang'] ?? "",
      id_user: map['id_user'] ?? "",
      nominal: map['nominal'] ?? 0,
      tanggal: map['tanggal'] != null
          ? (map['tanggal'] as Timestamp).toDate()
          : DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
    );
  }

  /// Convert Object → Firestore
  Map<String, dynamic> toMap() {
    return {
      "id_cabang": id_cabang,
      "id_user": id_user,
      "nominal": nominal,
      "tanggal": Timestamp.fromDate(tanggal),
    };
  }
}

class Jadwals extends ChangeNotifier {
  final List<Jadwal> _datas = [];
  bool isLoading = true;

  List<Jadwal> get datas => _datas;

  final _ref = FirebaseFirestore.instance.collection('jadwal');

  /// 🔹 Ambil semua jadwal
  Future<void> getJadwal() async {
    isLoading = true;
    notifyListeners();

    try {
      final today = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
      final snapshot = await _ref
          .where("tanggal", isGreaterThanOrEqualTo: Timestamp.fromDate(today))
          .get();

      _datas.clear();
      _datas.addAll(
        snapshot.docs.map((doc) => Jadwal.fromMap(doc.id, doc.data())).toList(),
      );
    } catch (e) {
      print("Error getJadwal: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  /// 🔹 Tambah jadwal
  Future<void> addJadwal({
    required String idUser,
    required String idCabang,
    required int nominal,
    required DateTime tanggal,
  }) async {
    try {
      final data = {
        "id_user": idUser,
        "id_cabang": idCabang,
        "nominal": nominal,
        "tanggal": Timestamp.fromDate(tanggal),
      };

      final doc = await _ref.add(data);

      _datas.add(
        Jadwal(
          id: doc.id,
          id_user: idUser,
          id_cabang: idCabang,
          nominal: nominal,
          tanggal: tanggal,
        ),
      );

      notifyListeners();
    } catch (e) {
      print("Error addJadwal: $e");
    }
  }

  /// 🔹 Hapus jadwal berdasarkan id
  Future<void> deleteById(String id) async {
    try {
      await _ref.doc(id).delete();
      _datas.removeWhere((j) => j.id == id);
      notifyListeners();
    } catch (e) {
      print("Error deleteById: $e");
    }
  }

  /// 🔹 Filter berdasarkan cabang
  List<Jadwal> getByCabang(String idCabang) {
    return _datas.where((d) => d.id_cabang == idCabang).toList();
  }

  /// 🔹 Cek jika user sudah pernah terdaftar di cabang tersebut
  bool exists(String idUser, String idCabang) {
    return _datas.any((d) => d.id_user == idUser && d.id_cabang == idCabang);
  }

  /// 🔹 Filter berdasarkan tanggal hari ini (opsional)
  List<Jadwal> getToday() {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(Duration(days: 1));

    return _datas.where((d) {
      return d.tanggal.isAfter(start) && d.tanggal.isBefore(end);
    }).toList();
  }
}
