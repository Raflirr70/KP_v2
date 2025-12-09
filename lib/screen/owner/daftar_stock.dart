import 'package:flutter/material.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/screen/owner/daftar_makanan.dart';
import 'package:kerprak/widget/list/list_stock.dart';
import 'package:kerprak/widget/search/search_simple.dart';
import 'package:provider/provider.dart';

class DaftarStock extends StatefulWidget {
  const DaftarStock({super.key});

  @override
  State<DaftarStock> createState() => _DaftarStockState();
}

class _DaftarStockState extends State<DaftarStock> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Makanans>(context, listen: false).getMakanan();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Cabangs>(context, listen: false).getCabang();
    });

    _searchController.addListener(() {
      setState(() {}); // Trigger rebuild untuk filter list
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Makanans>(
      builder: (context, value, child) {
        if (value.isLoading) return Center(child: CircularProgressIndicator());

        // Filter langsung tanpa provider
        List<Makanan> filtered = value.datas
            .where(
              (u) => u.nama.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              ),
            )
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: Text("Stock Makanan"),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: Icon(Icons.arrow_back_ios_new_sharp),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DaftarMakanan()),
                  );
                },
                icon: Icon(Icons.warehouse_rounded),
              ),
            ],
          ),
          body: SafeArea(
            child: Center(
              child: Column(
                children: [
                  SearchSimple(controller: _searchController),
                  SizedBox(height: 10, width: 250, child: Divider(height: 2)),
                  Expanded(child: ListStock(value: filtered)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
