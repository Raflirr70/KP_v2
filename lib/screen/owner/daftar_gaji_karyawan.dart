import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/user.dart';
import 'package:kerprak/widget/list/list_gaji_karyawan.dart';
import 'package:kerprak/widget/menu/dashboard_admin_menu.dart';
import 'package:provider/provider.dart';

class DaftarGajiKaryawan extends StatefulWidget {
  const DaftarGajiKaryawan({super.key});

  @override
  State<DaftarGajiKaryawan> createState() => _DaftarGajiKaryawanState();
}

class _DaftarGajiKaryawanState extends State<DaftarGajiKaryawan> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Cabangs>(context, listen: false).getCabang();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Users>(context, listen: false).fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kelola Gaji Karyawan"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardAdminMenu()),
            );
          },
          icon: Icon(Icons.arrow_back_ios_new_sharp),
        ),
      ),
      body: Consumer<Cabangs>(
        builder: (context, cabang, child) {
          if (cabang.isLoading)
            return Center(child: CircularProgressIndicator());
          return Column(
            children: [
              SizedBox(height: 16),
              SizedBox(height: 10, width: 250, child: Divider(height: 2)),
              Expanded(child: ListGajiKaryawan(value: cabang.datas)),
            ],
          );
        },
      ),
    );
  }
}
