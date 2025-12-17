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

  Stream<List<Stock>> streamStockByIdCabang(String idCabang) {
    return FirebaseFirestore.instance
        .collection('stock')
        .where("id_cabang", isEqualTo: idCabang)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Stock.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

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

  Future<void> getStocksByIdCabang(String idCabang) async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('stock')
          .where("id_cabang", isEqualTo: idCabang)
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

  Future<int> getTotalStockByMakanan(String idMakanan) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('stock')
          .where("id_makanan", isEqualTo: idMakanan)
          .get();

      int total = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data(); // ⬅ WAJIB CAST
        total += (data['jumlah_makanan'] ?? 0) as int; // ⬅ ACCESS AMAN
      }

      return total;
    } catch (e) {
      print("Error getTotalStockByCabang: $e");
      return 0;
    }
  }

  Future<int> getTotalStockByCabang(String idCabang) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('stock')
          .where("id_cabang", isEqualTo: idCabang)
          .get();

      int total = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data(); // ⬅ WAJIB CAST
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

  Future<void> updateStock(
    String idCabang,
    String idMakanan,
    int sisaBaru,
  ) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('stock')
          .where('id_cabang', isEqualTo: idCabang)
          .where('id_makanan', isEqualTo: idMakanan)
          .get();

      for (var doc in query.docs) {
        await doc.reference.update({"jumlah_stock": sisaBaru});
      }

      // update di local list
      int index = _datas.indexWhere(
        (x) => x.idCabang == idCabang && x.idMakanan == idMakanan,
      );

      if (index != -1) {
        _datas[index].jumlahStock = sisaBaru;
      }

      notifyListeners();
    } catch (e) {
      print("Error updateStock: $e");
    }
  }

  Future<void> updateStockJumlah({
    required String idCabang,
    required String idMakanan,
    required int jumlahBaru,
  }) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('stock')
          .where('id_cabang', isEqualTo: idCabang)
          .where('id_makanan', isEqualTo: idMakanan)
          .get();

      // Jika data tidak ditemukan
      if (snapshot.docs.isEmpty) {
        print("⚠️ Stock tidak ditemukan untuk makanan: $idMakanan");
        return;
      }

      // Update setiap dokumen yang ditemukan
      for (var doc in snapshot.docs) {
        await FirebaseFirestore.instance.collection('stock').doc(doc.id).update(
          {'jumlah': jumlahBaru},
        );
      }

      // Update list lokal (opsional)
      for (var s in _datas) {
        if (s.idCabang == idCabang && s.idMakanan == idMakanan) {
          s.jumlahStock = jumlahBaru;
        }
      }

      notifyListeners();
      print("✅ Stock $idMakanan berhasil diupdate: $jumlahBaru");
    } catch (e) {
      print("❌ Error update stock: $e");
    }
  }
}
