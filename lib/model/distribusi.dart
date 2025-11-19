import 'package:flutter/widgets.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/makanan.dart';

class Distribusi {
  Cabang dari;
  Cabang tujuan;
  Makanan makanan;
  int jumlah;

  Distribusi(this.dari, this.tujuan, this.makanan, this.jumlah);
}

class Distribusis extends ChangeNotifier {
  List<Distribusi> _datas = [
    Distribusi(Cabangs().datas[1], Cabangs().datas[2], Makanans().datas[1], 20),
    Distribusi(Cabangs().datas[2], Cabangs().datas[1], Makanans().datas[2], 40),
    Distribusi(Cabangs().datas[3], Cabangs().datas[1], Makanans().datas[3], 60),
  ];
  List<Distribusi> get datas => _datas;
}
