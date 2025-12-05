import 'package:flutter/material.dart';
import 'package:kerprak/model/pengeluaran.dart';
import 'package:kerprak/model/search.dart';
import 'package:kerprak/widget/popup/show_tambah_pengeluaran.dart';
import 'package:provider/provider.dart';

class ListPengeluaran extends StatelessWidget {
  final List<Pengeluaran> pluars;
  ListPengeluaran({super.key, required this.pluars});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      itemCount: pluars.length + 1,
      itemBuilder: (context, i) {
        if (i == pluars.length) {
          return InkWell(
            child: Card(
              color: Colors.lightBlue[100],
              elevation: 3,
              margin: EdgeInsets.only(bottom: 12),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Icon(Icons.add_circle),
              ),
            ),
            onTap: () => showTambahPengeluaranDialog(context),
          );
        }

        var pluar = pluars[i];

        return Card(
          shape: RoundedRectangleBorder(),
          elevation: 5,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          pluar.namaPengeluaran,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),

                        // Tombol Edit
                        ListTile(
                          leading: Icon(Icons.edit, color: Colors.blue),
                          title: Text("Edit"),
                          onTap: () {
                            Navigator.pop(context);
                            // Panggil halaman edit di sini
                            print("Edit ${pluar.namaPengeluaran}");
                          },
                        ),

                        // Tombol Hapus
                        ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text("Hapus"),
                          onTap: () {
                            Navigator.pop(context);

                            // alerPenghapusanKaryawan(
                            //   context,
                            //   onDelete: () {},
                            // );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text((i + 1).toString()),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: 2,
                    height: 25,
                    color: Colors.grey, // bisa diganti
                  ),

                  Text(
                    pluar.namaPengeluaran,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 60,
                    child: Text("${pluar.jumlahUnit} ${pluar.jenisSatuan}"),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: 2,
                    height: 25,
                    color: Colors.grey, // bisa diganti
                  ),
                  Text('Rp.${pluar.totalHarga}'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
