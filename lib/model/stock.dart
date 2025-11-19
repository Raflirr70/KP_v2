import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/makanan.dart';

class Stock {
  Makanan makanan;
  Cabang cabang;
  int stock;

  Stock(this.makanan, this.cabang, this.stock);
}

class Stocks extends ChangeNotifier {
  Makanans m = Makanans();
  Cabangs c = Cabangs();
  late List<Stock> _datas;
  List<Stock> get datas => _datas;

  Stocks() {
    final m = Makanans();
    final c = Cabangs();

    _datas = [
      for (int a = 0; a < m.datas.length; a++)
        for (int b = 0; b < c.datas.length; b++)
          Stock(m.datas[a], c.datas[b], a * b),
    ];
  }

  int getJumlah(int idCabang, int idMakanan) {
    try {
      final item = _datas.firstWhere(
        (e) => e.cabang.id == idCabang && e.makanan.id == idMakanan,
      );
      return item.stock;
    } catch (e) {
      return 0;
    }
  }

  int getTotalCabang(int idMakanan) {
    int total = 0;

    for (var item in _datas) {
      if (item.makanan.id == idMakanan) {
        total += item.stock;
      }
    }

    return total;
  }
}
