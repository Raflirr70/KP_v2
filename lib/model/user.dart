import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> Login(String _emailCtrl, String _passwordCtrl) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCtrl,
        password: _passwordCtrl,
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>?> get_data() async {
    try {
      // Ambil dokumen dari Firestore
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection("akun")
          .doc("P6u50eyj9EZK69caVDRokD94Bwp2")
          .get();

      // Jika dokumen ada, kembalikan data-nya
      if (doc.exists) {
        return doc.data();
      } else {
        return null; // dokumen tidak ada
      }
    } catch (e) {
      print("Error mengambil data: $e");
      return null; // terjadi error
    }
  }
}
