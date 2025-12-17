import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kerprak/model/search.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String id;
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

  Future<void> editKaryawan(
    String idUser, {
    required String nama,
    required String email,
  }) async {
    try {
      // Update Firestore berdasarkan document ID
      await FirebaseFirestore.instance.collection("akun").doc(idUser).update({
        "nama": nama,
        "email": email,
      });

      // UPDATE LIST LOKAL
      int index = _datas.indexWhere((u) => u.id == idUser);
      if (index != -1) {
        _datas[index].nama = nama;
        _datas[index].email = email;
      }

      notifyListeners();
    } catch (e) {
      print("Error editKaryawan: $e");
      rethrow;
    }
  }

  void hapus(int id) {
    _datas.removeWhere((user) => user.id == id);
    notifyListeners();
  }

  Future<bool> Login(String emailCtrl, String passwordCtrl) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl,
        password: passwordCtrl,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
      return false;
    }
  }

  // Load semua data dari Firestore dan update _datas
  Stream<List<User>> streamKaryawanByCabang(String idCabang) {
    return FirebaseFirestore.instance
        .collection('akun')
        .where('role', isEqualTo: 'karyawan')
        .where('idCabang', isEqualTo: idCabang) // asumsi field idCabang ada
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            var data = doc.data();
            return User(
              doc.id,
              data['role'] ?? '',
              data['nama'] ?? '',
              data['email'] ?? '',
              data['password'] ?? '',
            );
          }).toList(),
        );
  }

  Future<void> simpanSP({
    required String nama,
    required String idCabang,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nama', nama);
      await prefs.setString('idCabang', idCabang);
      print("SharedPreferences berhasil disimpan: $nama, $idCabang");
    } catch (e) {
      print("Error simpanSP: $e");
    }
  }

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
            doc.id,
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
          docRef.id, // ID lokal bisa dari hash ID dokumen
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
