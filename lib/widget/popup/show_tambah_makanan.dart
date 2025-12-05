import 'package:flutter/material.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:provider/provider.dart';

void showTambahMakananDialog(BuildContext context) {
  final _formKey = GlobalKey<FormState>();
  String nama = '';
  int harga = 0;

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
                  "Tambah Makanan",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Nama Makanan
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Nama Makanan",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.fastfood),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? "Nama harus diisi"
                            : null,
                        onChanged: (value) => nama = value,
                      ),
                      SizedBox(height: 12),

                      // Harga Makanan
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Harga",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.money),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Harga harus diisi";
                          }
                          if (int.tryParse(value) == null) {
                            return "Harga harus angka";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          harga = int.tryParse(value) ?? 0;
                        },
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
                                final messenger = ScaffoldMessenger.of(context);

                                // Buat objek makanan
                                final makanan = Makanan(
                                  id: "", // sementara kosong, Firestore generate
                                  nama: nama,
                                  harga: harga,
                                  stocks: [],
                                );

                                // Simpan ke Firestore
                                await Provider.of<Makanans>(
                                  context,
                                  listen: false,
                                ).tambahMakanan(makanan);

                                Navigator.of(context).pop();

                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Berhasil menambahkan makanan!",
                                    ),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Gagal menambahkan: $e"),
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
