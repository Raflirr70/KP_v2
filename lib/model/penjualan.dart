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
  TimeOfDay? jam;

  tambah(DetailPenjualan detail) {
    _detail.add(detail);
    notifyListeners();
  }
}

class Penjualans extends ChangeNotifier {
  final List<Penjualan> _datas = [
    Penjualan()
      ..id = 1
      ..tambah(DetailPenjualan(1, "Nasi Goreng", 2, 30000))
      ..tambah(DetailPenjualan(2, "Es Teh", 2, 10000))
      ..total_harga = 40000
      ..jam = TimeOfDay(hour: 12, minute: 30),

    Penjualan()
      ..id = 2
      ..tambah(DetailPenjualan(3, "Ayam Bakar", 1, 25000))
      ..tambah(DetailPenjualan(4, "Jus Alpukat", 1, 15000))
      ..total_harga = 40000
      ..jam = TimeOfDay(hour: 13, minute: 01),

    Penjualan()
      ..id = 3
      ..tambah(DetailPenjualan(5, "Mie Ayam", 3, 45000))
      ..tambah(DetailPenjualan(6, "Teh Hangat", 3, 9000))
      ..total_harga = 54000
      ..jam = TimeOfDay(hour: 13, minute: 10),
  ];
  List<Penjualan> get datas => _datas;

  tambah(Penjualan x) {
    _datas.add(x);
    notifyListeners();
  }
}
