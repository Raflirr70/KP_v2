import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/jadwal.dart';
import 'package:kerprak/model/user.dart';
import 'package:kerprak/widget/list/list_penjadwalan.dart';
import 'package:kerprak/widget/menu/dashboard_admin_menu.dart';
import 'package:provider/provider.dart';

class PenjadwalanPage extends StatefulWidget {
  const PenjadwalanPage({super.key});

  @override
  State<PenjadwalanPage> createState() => _PenjadwalanPageState();
}

class _PenjadwalanPageState extends State<PenjadwalanPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Cabangs>(context, listen: false).getCabang();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Users>(context, listen: false).fetchData();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Jadwals>(context, listen: false).getJadwal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Jadwals>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardAdminMenu()),
                );
              },
              icon: Icon(Icons.arrow_back_ios_new_sharp),
            ),
            title: Text("Penjadwalan Karyawan"),
            centerTitle: true,
          ),
          body: Consumer<Cabangs>(
            builder: (context, cabang, child) {
              if (cabang.isLoading)
                return Center(child: CircularProgressIndicator());
              return Column(
                children: [
                  SizedBox(height: 16),
                  SizedBox(height: 10, width: 250, child: Divider(height: 2)),
                  Expanded(child: ListPenjadwalan(value: cabang.datas)),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
