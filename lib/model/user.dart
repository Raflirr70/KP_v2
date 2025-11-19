import 'package:flutter/material.dart';

class User {
  int id;
  String role;
  String nama;
  String email;
  String password;
  User(this.id, this.role, this.nama, this.email, this.password);
}

class Users extends ChangeNotifier {
  final List<User> _datas = [
    User(1, "owner", "steve", "steve@gmail.com", "123456"),
    User(2, "karyawan", "ujang", "ujang@gmail.com", "123456"),
  ];

  List<User> get datas => _datas;

  void tambah(User x) {
    _datas.add(x);
    notifyListeners();
  }

  void hapus(int id) {
    _datas.removeWhere((user) => user.id == id);
    notifyListeners();
  }

  // Fungsi login beneran
  User? login(String email, String pass) {
    try {
      return _datas.firstWhere(
        (u) => u.email == email.trim() && u.password == pass,
      );
    } catch (e) {
      return null;
    }
  }
}
