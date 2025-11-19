import 'package:flutter/material.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/search.dart';
import 'package:provider/provider.dart';

class ListMakanan extends StatelessWidget {
  Makanans value;
  ListMakanan({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<SearchProvider>(
        builder: (context, sp, child) {
          return ListView.builder(
            itemCount: sp.filtered.length,
            itemBuilder: (context, i) {
              // Nama hasil filter
              var nama = sp.filtered[i];

              // Mencari user yang nama-nya sama
              var makanan = value.datas.firstWhere((u) => u.nama == nama);

              return Card(
                shape: RoundedRectangleBorder(),
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (_) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                nama,
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
                                  print("Edit $nama");
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
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
                          nama,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Text('Rp.${value.datas[i].harga}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
