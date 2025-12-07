import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Penggajian {
  String id;
  String id_pegawai;
  String id_laporan;
  int gaji;

  Penggajian({
    required this.id,
    required this.id_pegawai,
    required this.id_laporan,
    required this.gaji,
  });

  factory Penggajian.fromMap(String id, Map<String, dynamic> map) {
    return Penggajian(
      id: id,
      id_pegawai: map['id_user'] ?? '',
      id_laporan: map['id_laporan'] ?? '',
      gaji: map['gaji'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {"id_user": id_pegawai, "id_laporan": id_laporan, "gaji": gaji};
  }
}

class Penggajians extends ChangeNotifier {
  final List<Penggajian> _datas = [];
  bool isLoading = true;

  List<Penggajian> get datas => _datas;

  Future<void> getPenggajian() async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('penggajian')
          .get();

      _datas.clear();
      _datas.addAll(
        snapshot.docs.map((doc) {
          return Penggajian.fromMap(doc.id, doc.data());
        }).toList(),
      );
    } catch (e) {
      print("Error getPenggajian: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> simpanGaji(String idPegawai, String idLaporan, int gaji) async {
    try {
      // cek apakah sudah ada gaji
      final cek = _datas.firstWhere(
        (g) => g.id_pegawai == idPegawai && g.id_laporan == idLaporan,
        orElse: () =>
            Penggajian(id: '', id_pegawai: '', id_laporan: '', gaji: 0),
      );

      if (cek.id.isEmpty) {
        // ➤ BELUM ADA → TAMBAHKAN BARU
        final doc = await FirebaseFirestore.instance
            .collection('penggajian')
            .add({"id_user": idPegawai, "id_laporan": idLaporan, "gaji": gaji});

        _datas.add(
          Penggajian(
            id: doc.id,
            id_pegawai: idPegawai,
            id_laporan: idLaporan,
            gaji: gaji,
          ),
        );
      } else {
        // ➤ SUDAH ADA → UPDATE
        await FirebaseFirestore.instance
            .collection('penggajian')
            .doc(cek.id)
            .update({"gaji": gaji});

        cek.gaji = gaji;
      }

      notifyListeners();
    } catch (e) {
      print("Error simpanGaji: $e");
    }
  }
}
