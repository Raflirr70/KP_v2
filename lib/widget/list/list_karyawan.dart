import 'package:flutter/material.dart';
import 'package:kerprak/model/search.dart';
import 'package:kerprak/model/user.dart';
import 'package:kerprak/widget/popup/alert_penghapusan_karyawan.dart';
import 'package:provider/provider.dart';

class ListKaryawan extends StatelessWidget {
  Users value;
  ListKaryawan({super.key, required this.value});

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
              var user = value.datas.firstWhere((u) => u.nama == nama);

              return Card(
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

                                  alerPenghapusanKaryawan(
                                    context,
                                    onDelete: () {},
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nama,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            SizedBox(width: 100, child: Text("Role")),
                            Text(": ${user.role}"),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 100, child: Text("Email")),
                            Text(": ${user.email}"),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 100, child: Text("Password")),
                            Text(": ${user.password}"),
                          ],
                        ),
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
