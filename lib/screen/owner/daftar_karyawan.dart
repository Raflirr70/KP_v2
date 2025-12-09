import 'package:flutter/material.dart';

import 'package:kerprak/model/user.dart';
import 'package:kerprak/widget/list/list_karyawan.dart';
import 'package:kerprak/widget/search/search_simple.dart';
import 'package:provider/provider.dart';

class DaftarKaryawan extends StatefulWidget {
  const DaftarKaryawan({super.key});

  @override
  State<DaftarKaryawan> createState() => _DaftarKaryawanState();
}

class _DaftarKaryawanState extends State<DaftarKaryawan> {
  TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Users>(context, listen: false).fetchData();
    });

    _searchCtrl.addListener(() {
      setState(() {}); // Trigger rebuild untuk filter list
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Kelola Karyawan"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Consumer<Users>(
        builder: (context, users, child) {
          if (users.isLoading)
            return Center(child: CircularProgressIndicator());

          // Filter langsung tanpa provider
          List<User> filtered = users.datas
              .where(
                (u) =>
                    u.role != "admin" &&
                    u.nama.toLowerCase().contains(
                      _searchCtrl.text.toLowerCase(),
                    ),
              )
              .toList();

          return Column(
            children: [
              SizedBox(height: 16),
              SearchSimple(controller: _searchCtrl),
              SizedBox(height: 10, width: 250, child: Divider(height: 2)),
              Expanded(child: ListKaryawan(users: filtered)),
            ],
          );
        },
      ),
    );
  }
}
