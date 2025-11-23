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

  int hitungTotal() {
    int total_harga = _detail.fold(0, (sum, item) => sum + item.total_harga);
    return total_harga;
  }
}

class Penjualans extends ChangeNotifier {
  final List<Penjualan> _datas = [
    Penjualan()
      ..id = 1
      ..tambah(DetailPenjualan(1, "Nasi", 2, 30000))
      ..tambah(DetailPenjualan(2, "Rendang", 2, 10000))
      ..tambah(DetailPenjualan(2, "Ayam Goreng", 3, 10000))
      ..tambah(DetailPenjualan(2, "Sambal", 2, 10000))
      ..tambah(DetailPenjualan(2, "Kikil", 2, 10000))
      ..total_harga = 40000
      ..jam = TimeOfDay(hour: 12, minute: 30),

    Penjualan()
      ..id = 2
      ..tambah(DetailPenjualan(3, "Nasi", 1, 25000))
      ..tambah(DetailPenjualan(4, "Ayam Bakar", 1, 15000))
      ..total_harga = 40000
      ..jam = TimeOfDay(hour: 13, minute: 01),

    Penjualan()
      ..id = 3
      ..tambah(DetailPenjualan(5, "Ayam Goreng", 3, 45000))
      ..total_harga = 54000
      ..jam = TimeOfDay(hour: 13, minute: 10),
  ];
  List<Penjualan> get datas => _datas;

  tambah(Penjualan x) {
    _datas.add(x);
    notifyListeners();
  }
}
