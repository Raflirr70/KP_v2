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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Users>(context, listen: false).fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return Scaffold(
      backgroundColor: Colors.grey[50], // Lebih lembut dari grey[100]
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16), // atur radius sesukamu
          ),
          child: AppBar(
            backgroundColor: Colors.blueAccent,
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    "Kelola Karyawan",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    textAlign: TextAlign.end,
                  ),
                ),
                SizedBox(width: 20),
                Icon(Icons.temple_buddhist_outlined),
              ],
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Consumer<Users>(
        builder: (context, users, child) {
          if (users.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          // print(users.datas.length);
          return Column(
            children: [
              SizedBox(height: 16),
              SearchSimple(data: users.datas.map((e) => e.nama).toList()),

              SizedBox(height: 10, width: 250, child: Divider(height: 2)),
              ListKaryawan(value: users),
            ],
          );
        },
      ),
    );
  }
}
