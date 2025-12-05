import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kerprak/model/pengeluaran.dart';

/// Fungsi untuk menampilkan BottomSheet menambahkan pengeluaran
void showTambahPengeluaranDialog(BuildContext context) {
  final namaC = TextEditingController();
  final jumlahC = TextEditingController();
  final satuanC = TextEditingController();
  final hargaC = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Tambah Pengeluaran",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            buildField("Nama Pengeluaran", namaC),
            buildField("Jumlah", jumlahC, keyboardType: TextInputType.number),
            buildField("Jenis Satuan", satuanC),
            buildField("Harga", hargaC, keyboardType: TextInputType.number),

            SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                final nama = namaC.text.trim();
                final jumlah = int.tryParse(jumlahC.text.trim()) ?? 0;
                final satuan = satuanC.text.trim();
                final harga = int.tryParse(hargaC.text.trim()) ?? 0;

                if (nama.isEmpty ||
                    jumlah <= 0 ||
                    satuan.isEmpty ||
                    harga <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Isi semua field dengan benar")),
                  );
                  return;
                }

                // Buat objek Pengeluaran baru
                final newPengeluaran = Pengeluaran(
                  DateTime.now().millisecondsSinceEpoch
                      .toString(), // id sementara
                  "", // idCabang bisa diisi sesuai kebutuhan
                  nama,
                  jumlah,
                  satuan,
                  harga,
                );

                // Simpan ke Provider
                Provider.of<Pengeluarans>(
                  context,
                  listen: false,
                ).tambah(newPengeluaran);

                Navigator.pop(context);
              },
              icon: Icon(Icons.save),
              label: Text("Simpan"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 45),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}

/// Widget TextField umum
Widget buildField(
  String label,
  TextEditingController c, {
  TextInputType keyboardType = TextInputType.text,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: c,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    ),
  );
}
