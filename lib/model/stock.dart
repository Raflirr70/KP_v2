import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Stock {
  String id; // id dokumen stock
  String refCabang; // path referensi cabang ("cabang/<id>")
  int jumlahStock;

  Stock({required this.id, required this.refCabang, required this.jumlahStock});

  factory Stock.fromMap(String id, Map<String, dynamic> map) {
    return Stock(
      id: id,
      refCabang: map['cabang'], // ← path referensi
      jumlahStock: map['jumlah_stock'],
    );
  }

  Map<String, dynamic> toMap() {
    return {"cabang": refCabang, "jumlah_stock": jumlahStock};
  }
}

class Stocks extends ChangeNotifier {
  List<Stock> _datas = [];
  List<Stock> get datas => _datas;

  /// GET STOCK berdasarkan id makanan
  Future<void> getStock(String idMakanan) async {
    try {
      final ref = FirebaseFirestore.instance
          .collection("makanan")
          .doc(idMakanan)
          .collection("stock");

      final snapshot = await ref.get();

      _datas = snapshot.docs.map((d) => Stock.fromMap(d.id, d.data())).toList();

      notifyListeners();
    } catch (e) {
      print("Error getStock: $e");
    }
  }

  /// Ambil jumlah stok berdasarkan id cabang
  int getJumlah(String idCabang) {
    final stock = _datas.firstWhere(
      (d) => d.refCabang == "cabang/$idCabang",
      orElse: () => Stock(id: "", refCabang: "", jumlahStock: 0),
    );
    return stock.jumlahStock;
  }

  /// Total seluruh cabang
  int getTotal() {
    return _datas.fold(0, (sum, s) => sum + s.jumlahStock);
  }
}
