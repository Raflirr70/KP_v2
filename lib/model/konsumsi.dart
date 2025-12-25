import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class DetailKonsumsi {
  String idMakanan;
  int jumlah;

  DetailKonsumsi({required this.idMakanan, required this.jumlah});

  factory DetailKonsumsi.fromMap(String id, Map<String, dynamic> map) {
    return DetailKonsumsi(idMakanan: map['id_makanan'], jumlah: map['jumlah']);
  }

  Map<String, dynamic> toMap() {
    return {'id_makanan': idMakanan, 'jumlah': jumlah};
  }
}

class Konsumsi {
  String id; // 🔥 ID DOKUMEN FIRESTORE
  String idLaporan;
  String idKaryawan;
  String jam;
  List<DetailKonsumsi> detailKonsumsi;

  Konsumsi({
    required this.id,
    required this.idLaporan,
    required this.idKaryawan,
    required this.jam,
    required this.detailKonsumsi,
  });

  factory Konsumsi.fromMap(String id, Map<String, dynamic> map) {
    return Konsumsi(
      id: id,
      idLaporan: map['id_laporan'],
      idKaryawan: map['id_karyawan'],
      jam: map['jam'],
      detailKonsumsi: (map['detail_konsumsi'] as List)
          .map((e) => DetailKonsumsi.fromMap('', e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_laporan': idLaporan,
      'id_karyawan': idKaryawan,
      'jam': jam,
      'detail_konsumsi': detailKonsumsi.map((e) => e.toMap()).toList(),
    };
  }
}

class Konsumsis extends ChangeNotifier {
  final _konsumsiRef = FirebaseFirestore.instance.collection('konsumsi');
  final _stockRef = FirebaseFirestore.instance.collection('stock');

  Stream<List<Konsumsi>> streamKonsumsiByLaporan(String idLaporan) {
    return _konsumsiRef
        .where('id_laporan', isEqualTo: idLaporan)
        .snapshots()
        .map(
          (s) => s.docs.map((d) => Konsumsi.fromMap(d.id, d.data())).toList(),
        );
  }

  // ================= TAMBAH =================
  Future<void> tambahKonsumsi(Konsumsi konsumsi) async {
    try {
      final doc = FirebaseFirestore.instance.collection('konsumsi').doc();

      final jamSekarang = DateFormat('HH:mm').format(DateTime.now());

      await doc.set({...konsumsi.toMap(), 'jam': jamSekarang});
    } catch (e) {
      print("Error tambahKonsumsi: $e");
    }
  }

  // ================= HAPUS + KEMBALIKAN STOCK =================
  Future<void> hapusKonsumsiDanKembalikanStock({
    required Konsumsi konsumsi,
    required String idCabang,
  }) async {
    try {
      for (var d in konsumsi.detailKonsumsi) {
        final stockSnap = await _stockRef
            .where('id_makanan', isEqualTo: d.idMakanan)
            .where('id_cabang', isEqualTo: idCabang)
            .limit(1)
            .get();

        if (stockSnap.docs.isNotEmpty) {
          final doc = stockSnap.docs.first;
          final currentStock = doc['jumlah_makanan'];

          await _stockRef.doc(doc.id).update({
            'jumlah_makanan': currentStock + d.jumlah, // 🔥 RESTORE
          });
        }
      }

      // 🔥 HAPUS DATA KONSUMSI
      await _konsumsiRef.doc(konsumsi.id).delete();
    } catch (e) {
      print("ERROR HAPUS KONSUMSI: $e");
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
