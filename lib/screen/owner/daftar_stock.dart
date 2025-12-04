import 'package:flutter/material.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/search.dart';
import 'package:kerprak/model/stock.dart';
import 'package:kerprak/screen/owner/daftar_makanan.dart';
import 'package:kerprak/widget/list/list_stock.dart';
import 'package:kerprak/widget/menu/dashboard_admin_menu.dart';
import 'package:kerprak/widget/search/search_simple.dart';
import 'package:provider/provider.dart';

class DaftarStock extends StatefulWidget {
  const DaftarStock({super.key});

  @override
  State<DaftarStock> createState() => _DaftarStockState();
}

class _DaftarStockState extends State<DaftarStock> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<Stocks, Makanans>(
      builder: (context, stock, makanan, child) {
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
                  // SearchSimple(data: makanan.datas.map((e) => e.nama).toList()),
                  // SizedBox(height: 10, width: 250, child: Divider(height: 2)),

                  // Expanded(child: ListStock(value: makanan)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
