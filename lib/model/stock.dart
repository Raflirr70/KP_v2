import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Stock {
  String id;
  String idCabang;
  String idMakanan;
  int jumlahStock;

  Stock({
    required this.id,
    required this.idCabang,
    required this.idMakanan,
    required this.jumlahStock,
  });

  factory Stock.fromMap(String id, Map<String, dynamic> map) {
    return Stock(
      id: id,
      idCabang: map['id_cabang'] ?? '',
      idMakanan: map['id_makanan'] ?? '',
      jumlahStock: map['jumlah_makanan'] ?? 0,
    );
  }
}

class Stocks extends ChangeNotifier {
  final List<Stock> _datas = [];
  bool isLoading = false;

  List<Stock> get datas => _datas;

  /// Ambil semua stock
  Future<void> getAllStocks() async {
    isLoading = true;
    notifyListeners();
    print("Masuk fungsi");

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('stock')
          .get();

      _datas.clear();
      _datas.addAll(
        snapshot.docs.map((doc) {
          var data = doc.data();
          return Stock.fromMap(doc.id, data);
        }).toList(),
      );
    } catch (e) {
      print("Error getMakanan: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  /// Ambil semua stock
  Future<void> getStocksById(String idMakanan) async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('stock')
          .where("id_makanan", isEqualTo: idMakanan)
          .get();

      _datas.clear();
      _datas.addAll(
        snapshot.docs.map((doc) {
          var data = doc.data();
          return Stock.fromMap(doc.id, data);
        }).toList(),
      );
    } catch (e) {
      print("Error getMakanan: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<int> getTotalStockByCabang(String idMakanan) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('stock')
          .where("id_makanan", isEqualTo: idMakanan)
          .get();

      int total = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>; // ⬅ WAJIB CAST
        total += (data['jumlah_makanan'] ?? 0) as int; // ⬅ ACCESS AMAN
      }

      return total;
    } catch (e) {
      print("Error getTotalStockByCabang: $e");
      return 0;
    }
  }

  /// Simpan atau update stock
  Future<void> saveStock({
    required String idMakanan,
    required String idCabang,
    required int jumlahStock,
  }) async {
    try {
      // Query: cari dulu apakah stok ini sudah ada
      final snapshot = await FirebaseFirestore.instance
          .collection('stock')
          .where("id_makanan", isEqualTo: idMakanan)
          .where("id_cabang", isEqualTo: idCabang)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // ============================================
        // UPDATE DATA
        // ============================================
        final docId = snapshot.docs.first.id;

        await FirebaseFirestore.instance.collection('stock').doc(docId).update({
          "jumlah_makanan": jumlahStock,
        });

        print("UPDATE STOCK: $idCabang = $jumlahStock");
      } else {
        // ============================================
        // CREATE DATA BARU
        // ============================================
        await FirebaseFirestore.instance.collection('stock').add({
          "id_makanan": idMakanan,
          "id_cabang": idCabang,
          "jumlah_makanan": jumlahStock,
        });

        print("CREATE STOCK: $idCabang = $jumlahStock");
      }

      await getStocksById(idMakanan); // refresh data
    } catch (e) {
      print("Error saveStock: $e");
    }
  }
}
