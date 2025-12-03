import 'package:flutter/material.dart';
import 'package:kerprak/model/search.dart';
import 'package:kerprak/model/user.dart';
import 'package:kerprak/widget/dll/inforow.dart';
import 'package:kerprak/widget/popup/alert_penghapusan_karyawan.dart';
import 'package:kerprak/widget/popup/show_tambah_karyawan.dart';
import 'package:provider/provider.dart';

class ListKaryawan extends StatefulWidget {
  Users value;
  ListKaryawan({super.key, required this.value});

  @override
  State<ListKaryawan> createState() => _ListKaryawanState();
}

class _ListKaryawanState extends State<ListKaryawan> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sp = Provider.of<SearchProvider>(context, listen: false);
      sp.setData(
        widget.value.datas
            .where((e) => e.role != "admin") // filter role bukan admin
            .map((e) => e.nama)
            .toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<SearchProvider>(
        builder: (context, sp, child) {
          final filtered = sp.filtered;

          if (filtered.isEmpty) {
            return Center(
              child: Text(
                "Tidak ada karyawan tersedia",
                style: TextStyle(color: Colors.grey[600]),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            itemCount: filtered.length + 1,
            itemBuilder: (context, i) {
              if (i == filtered.length) {
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
                  onTap: () {
                    showTambahKaryawanDialog(context);
                  },
                );
              }
              var nama = filtered[i];
              var user = widget.value.datas.firstWhere((u) => u.nama == nama);

              return Card(
                elevation: 3,
                margin: EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
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
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              ListTile(
                                leading: Icon(Icons.edit, color: Colors.blue),
                                title: Text("Edit"),
                                onTap: () {
                                  Navigator.pop(context);
                                  print("Edit $nama");
                                },
                              ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text((i + 1).toString()),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              infoRow(Icons.person, "Nama", user.nama),
                              SizedBox(height: 6),
                              infoRow(Icons.email, "Email", user.email),
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
        },
      ),
    );
  }
}
