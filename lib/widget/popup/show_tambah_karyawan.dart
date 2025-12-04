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
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Tambah Karyawan",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Nama
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Nama",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? "Nama harus diisi"
                            : null,
                        onChanged: (value) => nama = value,
                      ),
                      SizedBox(height: 12),

                      // Email
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            value == null || !value.contains("@")
                            ? "Email tidak valid"
                            : null,
                        onChanged: (value) => email = value,
                      ),
                      SizedBox(height: 12),

                      // Password
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.key),
                        ),
                        obscureText: true,
                        validator: (value) => value == null || value.length < 6
                            ? "Password minimal 6 karakter"
                            : null,
                        onChanged: (value) => password = value,
                      ),
                      SizedBox(height: 20),

                      // Tombol Simpan
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                // Simpan reference ke ScaffoldMessenger SEBELUM menutup dialog
                                final messenger = ScaffoldMessenger.of(context);

                                // Tambah karyawan
                                await Provider.of<Users>(
                                  context,
                                  listen: false,
                                ).tambahKaryawan(
                                  nama: nama,
                                  email: email,
                                  password: password,
                                );

                                // Tutup dialog
                                Navigator.of(context).pop();

                                // Tampilkan snackbar
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Berhasil menambahkan karyawan!",
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } catch (e) {
                                // Jika error, tampilkan snackbar dari context dialog
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Gagal menambahkan karyawan: $e",
                                    ),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            }
                          },

                          child: Text("Simpan"),
                        ),
                      ),
                    ],
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
