import 'package:flutter/material.dart';

class DetailPenjualan {
  int id;
  String nama_makanan;
  int jumlah;
  int total_harga;

  DetailPenjualan(this.id, this.nama_makanan, this.jumlah, this.total_harga);
}

class Penjualan extends ChangeNotifier {
  int? id;
  List<DetailPenjualan> _detail = [];
  List<DetailPenjualan> get detail => _detail;
  int? total_harga;

  tambah(DetailPenjualan detail) {
    _detail.add(detail);
    notifyListeners();
  }
}

class Penjualans extends ChangeNotifier {
  final List<Penjualan> _datas = [];
  List<Penjualan> get datas => _datas;

  tambah(Penjualan x) {
    _datas.add(x);
    notifyListeners();
  }
}
