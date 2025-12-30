import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/jadwal.dart';
import 'package:kerprak/model/penggajian.dart';
import 'package:kerprak/model/user.dart';
import 'package:kerprak/widget/list/list_gaji_karyawan.dart';
import 'package:kerprak/widget/navbar/appbar_admin.dart';
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
      Provider.of<Users>(context, listen: false).fetchData();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Jadwals>(context, listen: false).getJadwal(DateTime.now());
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Penggajians>(context, listen: false).getPenggajian();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppbarAdmin(),
      ),
      body: Consumer<Cabangs>(
        builder: (context, cabang, child) {
          if (cabang.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
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
