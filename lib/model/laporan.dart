import 'package:flutter/material.dart';
import 'package:kerprak/model/pengeluaran.dart';
import 'package:kerprak/model/penjualan.dart';

class Laporan {
  int id;
  bool? status;
  List<String>? Karyawan;
  int? total_pendapatan;
  int? total_pengeluaran;
  List<Penjualans> penjualan = [];
  List<Pengeluarans> pengeluaran = [];

  Laporan(this.id);
}

class Laporans extends ChangeNotifier {
  List<Laporan> _datas = [];
  List<Laporan> get datas => _datas;

  tambah(Laporan x) {
    _datas.add(x);
  }
}
