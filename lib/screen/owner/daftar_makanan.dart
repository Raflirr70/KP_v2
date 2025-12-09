import 'package:flutter/material.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/screen/owner/daftar_stock.dart';
import 'package:kerprak/widget/list/list_makanan.dart';
import 'package:kerprak/widget/search/search_simple.dart';
import 'package:provider/provider.dart';

class DaftarMakanan extends StatefulWidget {
  const DaftarMakanan({super.key});

  @override
  State<DaftarMakanan> createState() => _DaftarMakananState();
}

class _DaftarMakananState extends State<DaftarMakanan> {
  final _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Makanans>(context, listen: false).getMakanan();
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
            title: Text("Menu Makanan"),
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
                    MaterialPageRoute(builder: (context) => DaftarStock()),
                  );
                },
                icon: Icon(Icons.menu_book),
              ),
            ],
          ),
          body: SafeArea(
            child: Center(
              child: Column(
                children: [
                  SearchSimple(controller: _searchController),
                  SizedBox(height: 10, width: 250, child: Divider(height: 2)),
                  ListMakanan(value: filtered),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
