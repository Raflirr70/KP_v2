import 'package:flutter/material.dart';
import 'package:kerprak/model/makanan.dart';

class Cabang {
  int id;
  String nama;

  Cabang(this.id, this.nama);
}

class Cabangs extends ChangeNotifier {
  final List<Cabang> _datas = [
    Cabang(0, "Gudang"),
    Cabang(1, "Cipanas"),
    Cabang(2, "Cimacan"),
    Cabang(3, "GSP"),
    Cabang(4, "Balakang"),
  ];
  List<Cabang> get datas => _datas;
}
