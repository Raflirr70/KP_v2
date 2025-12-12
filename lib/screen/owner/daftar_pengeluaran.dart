import 'package:flutter/material.dart';
import 'package:kerprak/model/pengeluaran.dart';
import 'package:kerprak/widget/list/list_pengeluaran.dart';
import 'package:kerprak/widget/menu/dashboard_admin_menu.dart';
import 'package:kerprak/widget/navbar/appbar_admin.dart';
import 'package:kerprak/widget/search/search_simple.dart';
import 'package:provider/provider.dart';

class DaftarPengeluaran extends StatefulWidget {
  const DaftarPengeluaran({super.key});

  @override
  State<DaftarPengeluaran> createState() => _DaftarPengeluaranState();
}

class _DaftarPengeluaranState extends State<DaftarPengeluaran> {
  TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Pengeluarans>(context, listen: false).fetchData();
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppbarAdmin(),
      ),
      body: Consumer<Pengeluarans>(
        builder: (context, pluars, child) {
          if (pluars.isLoading)
            return Center(child: CircularProgressIndicator());

          // Filter langsung tanpa provider
          List<Pengeluaran> filtered = pluars.datas
              .where(
                (u) => u.namaPengeluaran.toLowerCase().contains(
                  _searchCtrl.text.toLowerCase(),
                ),
              )
              .toList();

          return Column(
            children: [
              SizedBox(height: 16),
              SearchSimple(controller: _searchCtrl),
              SizedBox(height: 10, width: 250, child: Divider(height: 2)),
              Expanded(child: ListPengeluaran(pluars: filtered)),
            ],
          );
        },
      ),
    );
  }
}
