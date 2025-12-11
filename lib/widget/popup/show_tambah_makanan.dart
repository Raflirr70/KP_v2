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
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.orange[50],
        insetPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        title: Text(
          "Tambah Makanan",
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
                // Nama Makanan
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nama Makanan",
                    prefixIcon: Icon(Icons.fastfood),
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

                // Harga
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Harga",
                    prefixIcon: Icon(Icons.money),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Harga harus diisi";
                    }
                    if (int.tryParse(value) == null) {
                      return "Harga harus berupa angka";
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

                          final makanan = Makanan(
                            id: "",
                            nama: nama,
                            harga: harga,
                          );

                          await Provider.of<Makanans>(
                            context,
                            listen: false,
                          ).tambahMakanan(makanan);

                          Navigator.of(context).pop();

                          messenger.showSnackBar(
                            SnackBar(
                              content: Text("Berhasil menambahkan makanan!"),
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
