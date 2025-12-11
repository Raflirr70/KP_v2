import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kerprak/model/user.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kerprak/model/user.dart';

void showTambahKaryawanDialog(BuildContext context) {
  final _formKey = GlobalKey<FormState>();
  String nama = '';
  String email = '';
  String password = '';

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.orange[50],
        insetPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),

        title: Text(
          "Tambah Karyawan",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),

        contentPadding: EdgeInsets.zero,
        content: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // NAMA
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nama Karyawan",
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Nama harus diisi"
                      : null,
                  onChanged: (value) => nama = value,
                ),

                SizedBox(height: 12),

                // EMAIL
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: Icon(Icons.email),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || !value.contains("@")
                      ? "Email tidak valid"
                      : null,
                  onChanged: (value) => email = value,
                ),

                SizedBox(height: 12),

                // PASSWORD
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(Icons.key),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) => value == null || value.length < 6
                      ? "Password minimal 6 karakter"
                      : null,
                  onChanged: (value) => password = value,
                ),

                SizedBox(height: 20),

                // TOMBOL SIMPAN
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      "Simpan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          final messenger = ScaffoldMessenger.of(context);

                          await Provider.of<Users>(
                            context,
                            listen: false,
                          ).tambahKaryawan(
                            nama: nama,
                            email: email,
                            password: password,
                          );

                          Navigator.of(context).pop();

                          messenger.showSnackBar(
                            SnackBar(
                              content: Text("Berhasil menambahkan karyawan!"),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Gagal menambahkan karyawan: $e"),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
