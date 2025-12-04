import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kerprak/model/search.dart';
import 'package:provider/provider.dart';

class User {
  int id;
  String role;
  String nama;
  String email;
  String password;
  User(this.id, this.role, this.nama, this.email, this.password);
}

class Users extends ChangeNotifier {
  final List<User> _datas = [];
  bool isLoading = true;

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

  // Load semua data dari Firestore dan update _datas
  Future<void> fetchData() async {
    isLoading = true;
    notifyListeners();
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('akun')
          .get();

      _datas.clear();
      _datas.addAll(
        snapshot.docs.map((doc) {
          var data = doc.data();
          return User(
            data['id'] ?? 0,
            data['role'] ?? '',
            data['nama'] ?? '',
            data['email'] ?? '',
            data['password'] ?? '',
          );
        }).toList(),
      );
      isLoading = false;

      notifyListeners();
    } catch (e) {
      print("Error fetchData: $e");
    }
  }

  // ================== Fungsi Tambah Karyawan ==================
  Future<void> tambahKaryawan({
    required String nama,
    required String email,
    required String password,
    String role = "karyawan",
  }) async {
    try {
      // 1. Buat akun di Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // 2. Simpan data karyawan di Firestore
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('akun')
          .doc(userCredential.user!.uid.toString());
      await docRef.set({'nama': nama, 'email': email});

      // 3. Tambahkan ke list lokal
      _datas.add(
        User(
          docRef.id.hashCode, // ID lokal bisa dari hash ID dokumen
          role,
          nama,
          email,
          password,
        ),
      );

      fetchData();
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      print("Error tambahKaryawan: $e");
    }
  }

  Future<void> hapusKaryawan(User user) async {
    try {
      // 1️⃣ Hapus dari Firestore
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('akun')
          .where('email', isEqualTo: user.email)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      // 2️⃣ Hapus dari Firebase Auth
      // Catatan: Firebase Auth hanya bisa menghapus user yang sedang login
      // Jika ingin menghapus user lain, harus pakai Admin SDK di server
      // if (FirebaseAuth.instance.currentUser?.email == user.email) {
      //   await FirebaseAuth.instance.currentUser!.delete();
      // }

      // 3️⃣ Hapus dari list lokal
      _datas.removeWhere((u) => u.email == user.email);
      notifyListeners();
    } catch (e) {
      print("Error hapusKaryawan: $e");
    }
  }
}
