import 'package:flutter/material.dart';

class Pengeluaran {
  int id;
  String nama_pengeluaran;
  int jumlah_unit;
  String jenis_satuan;
  int total_harga;

  Pengeluaran(
    this.id,
    this.nama_pengeluaran,
    this.jumlah_unit,
    this.jenis_satuan,
    this.total_harga,
  );
}

class Pengeluarans extends ChangeNotifier {
  List<Pengeluaran> _datas = [
    Pengeluaran(0, "seblak", 2, "unit", 20000),
    Pengeluaran(1, "Mie", 5, "unit", 20000),
    Pengeluaran(2, "Kikil", 6, "unit", 20000),
    Pengeluaran(3, "Daging Ayam", 1, "unit", 20000),
    Pengeluaran(4, "Dagin Kambing", 2, "kg", 20000),
    Pengeluaran(5, "Cabe", 7, "kg", 20000),
  ];
  List<Pengeluaran> get datas => _datas;

  Tambah(Pengeluaran x) {
    _datas.add(x);
    notifyListeners();
  }
}
