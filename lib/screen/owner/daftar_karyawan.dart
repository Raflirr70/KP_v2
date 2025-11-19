import 'package:flutter/material.dart';
import 'package:kerprak/model/search.dart';
import 'package:kerprak/model/user.dart';
import 'package:kerprak/widget/list/list_karyawan.dart';
import 'package:kerprak/widget/popup/alert_penghapusan_karyawan.dart';
import 'package:kerprak/widget/search/search_simple.dart';
import 'package:provider/provider.dart';

class DaftarKaryawan extends StatefulWidget {
  const DaftarKaryawan({super.key});

  @override
  State<DaftarKaryawan> createState() => _DaftarKaryawanState();
}

class _DaftarKaryawanState extends State<DaftarKaryawan> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Users>(
      builder: (context, users, child) {
        return Scaffold(
          appBar: AppBar(title: Text("Daftar Karyawan"), centerTitle: true),
          body: SafeArea(
            child: Column(
              children: [
                // SearchSimple harus update SearchProvider
                SearchSimple(data: users.datas.map((e) => e.nama).toList()),

                SizedBox(height: 10, width: 250, child: Divider(height: 2)),

                ListKaryawan(value: users),
              ],
            ),
          ),
        );
      },
    );
  }
}
