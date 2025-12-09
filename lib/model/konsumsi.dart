import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Konsumsi {
  String id;
  String idLaporan;
  String namaKaryawan;
  String detailKonsumsi; // bisa berupa catatan umum

  Konsumsi({
    required this.id,
    required this.idLaporan,
    required this.namaKaryawan,
    required this.detailKonsumsi,
  });

  factory Konsumsi.fromMap(String id, Map<String, dynamic> map) {
    return Konsumsi(
      id: id,
      idLaporan: map['id_laporan'] ?? '',
      namaKaryawan: map['nama_karyawan'] ?? '',
      detailKonsumsi: map['detail_konsumsi'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id_laporan": idLaporan,
      "nama_karyawan": namaKaryawan,
      "detail_konsumsi": detailKonsumsi,
    };
  }
}

class DetailKonsumsi {
  String id;
  String idKonsumsi;
  String idMakanan;
  int jumlah; // optional kalau ingin track jumlah

  DetailKonsumsi({
    required this.id,
    required this.idKonsumsi,
    required this.idMakanan,
    this.jumlah = 1,
  });

  factory DetailKonsumsi.fromMap(String id, Map<String, dynamic> map) {
    return DetailKonsumsi(
      id: id,
      idKonsumsi: map['id_konsumsi'] ?? '',
      idMakanan: map['id_makanan'] ?? '',
      jumlah: map['jumlah'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id_konsumsi": idKonsumsi,
      "id_makanan": idMakanan,
      "jumlah": jumlah,
    };
  }
}

class Konsumsis extends ChangeNotifier {
  // Stream realtime semua konsumsi
  Stream<List<Konsumsi>> streamKonsumsi() {
    return FirebaseFirestore.instance
        .collection('konsumsi')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Konsumsi.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> tambahKonsumsi(Konsumsi konsumsi) async {
    try {
      final doc = FirebaseFirestore.instance.collection('konsumsi').doc();
      await doc.set(konsumsi.toMap());
    } catch (e) {
      print("Error tambahKonsumsi: $e");
    }
  }

  Future<void> hapusKonsumsi(String id) async {
    try {
      await FirebaseFirestore.instance.collection('konsumsi').doc(id).delete();
    } catch (e) {
      print("Error hapusKonsumsi: $e");
    }
  }
}

class DetailKonsumsis extends ChangeNotifier {
  // Stream realtime detail konsumsi berdasarkan id_konsumsi
  Stream<List<DetailKonsumsi>> streamDetailKonsumsi(String idKonsumsi) {
    return FirebaseFirestore.instance
        .collection('detail_konsumsi')
        .where('id_konsumsi', isEqualTo: idKonsumsi)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => DetailKonsumsi.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> tambahDetailKonsumsi(DetailKonsumsi detail) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection('detail_konsumsi')
          .doc();
      await doc.set(detail.toMap());
    } catch (e) {
      print("Error tambahDetailKonsumsi: $e");
    }
  }

  Future<void> hapusDetailKonsumsi(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('detail_konsumsi')
          .doc(id)
          .delete();
    } catch (e) {
      print("Error hapusDetailKonsumsi: $e");
    }
  }
}
