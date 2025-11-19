import 'package:flutter/material.dart';

class Makanan {
  int id;
  String nama;
  int harga;

  Makanan(this.id, this.nama, this.harga);
}

class Makanans extends ChangeNotifier {
  final List<Makanan> _datas = [
    Makanan(0, "Nasi Goreng Spesial", 18000),
    Makanan(1, "Mie Goreng Pedas", 15000),
    Makanan(2, "Ayam Geprek Sambal Ijo", 17000),
    Makanan(3, "Bakso Urat Jumbo", 20000),
    Makanan(4, "Sate Ayam Madura", 25000),
    Makanan(5, "Soto Ayam Lamongan", 16000),
    Makanan(6, "Burger Beef Single", 22000),
    Makanan(7, "Kentang Goreng Crispy", 12000),
    Makanan(8, "Es Teh Manis", 5000),
    Makanan(9, "Jus Jeruk Segar", 10000),
  ];

  List<Makanan> get datas => _datas;

  tambah(Makanan x) {
    _datas.add(x);
    notifyListeners();
  }
}
