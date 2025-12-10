import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/makanan.dart';

import 'package:flutter/foundation.dart';

class Distribusi {
  String id;
  String id_cabang_dari;
  String id_cabang_tujuan;
  String id_makanan;
  int jumlah;
  DateTime tanggal;

  Distribusi({
    required this.id,
    required this.id_cabang_dari,
    required this.id_cabang_tujuan,
    required this.id_makanan,
    required this.jumlah,
    required this.tanggal,
  });

  /// Konversi dari Firestore
  factory Distribusi.fromMap(String id, Map<String, dynamic> map) {
    return Distribusi(
      id: id,
      id_cabang_dari: map['id_cabang_dari'] ?? '',
      id_cabang_tujuan: map['id_cabang_tujuan'] ?? '',
      id_makanan: map['id_makanan'] ?? '',
      jumlah: map['jumlah'] ?? 0,
      tanggal: map['tanggal'] != null
          ? (map['tanggal'] as Timestamp).toDate()
          : DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
    );
  }

  /// Konversi ke Firestore
  Map<String, dynamic> toMap() {
    return {
      "id_cabang_dari": id_cabang_dari,
      "id_cabang_tujuan": id_cabang_tujuan,
      "id_makanan": id_makanan,
      "jumlah": jumlah,
      "tanggal": tanggal,
    };
  }
}

class Distribusis extends ChangeNotifier {
  final List<Distribusi> _datas = [];
  List<Distribusi> get datas => _datas;

  bool isLoading = false;

  /// 🔹 Generate ID otomatis
  String _generateId() =>
      FirebaseFirestore.instance.collection("distribusi").doc().id;

  /// 🔹 Ambil semua data distribusi
  Future<void> getDistribusi() async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("distribusi")
          .get();

      _datas.clear();
      _datas.addAll(
        snapshot.docs.map((doc) {
          return Distribusi.fromMap(doc.id, doc.data());
        }).toList(),
      );
    } catch (e) {
      print("Error getDistribusi: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getDistribusiHariIni() async {
    isLoading = true;
    notifyListeners();

    try {
      final today = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
      final snapshot = await FirebaseFirestore.instance
          .collection("distribusi")
          .where("tanggal", isGreaterThanOrEqualTo: Timestamp.fromDate(today))
          .get();

      _datas.clear();
      _datas.addAll(
        snapshot.docs.map((doc) {
          return Distribusi.fromMap(doc.id, doc.data());
        }).toList(),
      );
    } catch (e) {
      print("Error getDistribusi: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  /// 🔹 Tambah distribusi
  Future<void> addDistribusi({
    required String idCabangDari,
    required String idCabangTujuan,
    required String idMakanan,
    required int jumlah,
  }) async {
    final id = _generateId();

    final newData = Distribusi(
      id: id,
      id_cabang_dari: idCabangDari,
      id_cabang_tujuan: idCabangTujuan,
      id_makanan: idMakanan,
      jumlah: jumlah,
      tanggal: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
    );

    await FirebaseFirestore.instance
        .collection("distribusi")
        .doc(id)
        .set(newData.toMap());

    _datas.add(newData);
    notifyListeners();
  }

  /// 🔹 Hapus distribusi
  Future<void> deleteDistribusi(String id) async {
    await FirebaseFirestore.instance.collection("distribusi").doc(id).delete();

    _datas.removeWhere((d) => d.id == id);
    notifyListeners();
  }

  /// 🔹 Filter distribusi berdasarkan cabang asal
  List<Distribusi> getByCabangDari(String idCabang) {
    return _datas.where((d) => d.id_cabang_dari == idCabang).toList();
  }

  /// 🔹 Filter distribusi berdasarkan cabang tujuan
  List<Distribusi> getByCabangTujuan(String idCabang) {
    return _datas.where((d) => d.id_cabang_tujuan == idCabang).toList();
  }

  /// 🔹 Filter distribusi berdasarkan makanan
  List<Distribusi> getByMakanan(String idMakanan) {
    return _datas.where((d) => d.id_makanan == idMakanan).toList();
  }
}
