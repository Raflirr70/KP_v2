import 'package:flutter/material.dart';

class Pengeluaran {
  int id;
  int id_cabang;
  String nama_pengeluaran;
  int jumlah_unit;
  String jenis_satuan;
  int total_harga;

  Pengeluaran(
    this.id,
    this.id_cabang,
    this.nama_pengeluaran,
    this.jumlah_unit,
    this.jenis_satuan,
    this.total_harga,
  );
}

class Pengeluarans extends ChangeNotifier {
  List<Pengeluaran> _datas = [
    Pengeluaran(0, 1, "seblak", 2, "unit", 20000),
    Pengeluaran(1, 2, "Mie", 5, "unit", 20000),
    Pengeluaran(2, 2, "Kikil", 6, "unit", 20000),
    Pengeluaran(3, 3, "Daging Ayam", 1, "unit", 20000),
    Pengeluaran(4, 0, "Dagin Kambing", 2, "kg", 20000),
    Pengeluaran(5, 1, "Cabe", 7, "kg", 20000),
  ];
  List<Pengeluaran> get datas => _datas;

  Tambah(Pengeluaran x) {
    _datas.add(x);
    notifyListeners();
  }
}
