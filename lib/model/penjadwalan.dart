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
  final List<Penjadwalan> _datas = [];
  List<Penjadwalan> get datas => _datas;
}
