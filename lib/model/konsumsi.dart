import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DetailKonsumsi {
  String id;
  String idMakanan;
  int jumlah;

  DetailKonsumsi({required this.id, required this.idMakanan, this.jumlah = 1});

  factory DetailKonsumsi.fromMap(String id, Map<String, dynamic> map) {
    return DetailKonsumsi(
      id: id,
      idMakanan: map['id_makanan'] ?? '',
      jumlah: map['jumlah'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id_makanan': idMakanan, 'jumlah': jumlah};
  }
}

class Konsumsi {
  String id;
  String idLaporan;
  String idKaryawan;
  List<DetailKonsumsi> detailKonsumsi; // List detail

  Konsumsi({
    required this.id,
    required this.idLaporan,
    required this.idKaryawan,
    required this.detailKonsumsi,
  });

  factory Konsumsi.fromMap(String id, Map<String, dynamic> map) {
    var details = <DetailKonsumsi>[];
    if (map['detail_konsumsi'] != null) {
      details = List<Map<String, dynamic>>.from(map['detail_konsumsi']).map((
        d,
      ) {
        // Gunakan id dokumen dari map 'd' jika ada, atau buat kosong
        final detailId = d['id'] ?? '';
        return DetailKonsumsi(
          id: detailId,
          idMakanan: d['id_makanan'] ?? '',
          jumlah: d['jumlah'] ?? 1,
        );
      }).toList();
    }

    return Konsumsi(
      id: id,
      idLaporan: map['id_laporan'] ?? '',
      idKaryawan: map['id_karyawan'] ?? '',
      detailKonsumsi: details,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_laporan': idLaporan,
      'id_karyawan': idKaryawan,
      'detail_konsumsi': detailKonsumsi
          .map((d) => d.toMap()..['id'] = d.id)
          .toList(),
    };
  }
}

class Konsumsis extends ChangeNotifier {
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

  Stream<List<Konsumsi>> streamKonsumsiByLaporan(String idLaporan) {
    return FirebaseFirestore.instance
        .collection('konsumsi')
        .where('id_laporan', isEqualTo: idLaporan)
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
