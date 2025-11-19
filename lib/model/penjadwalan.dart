import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/user.dart';

class Penjadwalan {
  int? id;
  User user;
  Cabang cabang;

  Penjadwalan(this.user, this.cabang);
}

class Penjadwalans extends ChangeNotifier {
  final List<Penjadwalan> _datas = [
    Penjadwalan(Users().datas[1], Cabangs().datas[1]),
    Penjadwalan(Users().datas[1], Cabangs().datas[1]),

    Penjadwalan(Users().datas[0], Cabangs().datas[2]),
    Penjadwalan(Users().datas[0], Cabangs().datas[2]),

    Penjadwalan(Users().datas[1], Cabangs().datas[3]),
    Penjadwalan(Users().datas[0], Cabangs().datas[3]),
  ];
  List<Penjadwalan> get datas => _datas;
}
