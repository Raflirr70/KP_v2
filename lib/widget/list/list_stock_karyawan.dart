import 'package:flutter/material.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/stock.dart';
import 'package:provider/provider.dart';

class ListStockKaryawan extends StatefulWidget {
  final id_cabang;
  ListStockKaryawan({super.key, required this.id_cabang});

  @override
  State<ListStockKaryawan> createState() => _ListStockKaryawanState();
}

class _ListStockKaryawanState extends State<ListStockKaryawan> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Makanans>(context, listen: false).getMakanan();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Stocks>(
        context,
        listen: false,
      ).getStocksByIdCabang("HG4biWXd6vqIOJGunXXq");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.id_cabang == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Expanded(
      child: Consumer2<Stocks, Makanans>(
        builder: (context, stock, makanan, child) {
          print(stock.datas.length);
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: makanan.datas.length,
            itemBuilder: (context, index) {
              final filtered = stock.datas.firstWhere(
                (e) => e.idMakanan == makanan.datas[index].id,
                orElse: () => Stock(
                  id: "",
                  idCabang: widget.id_cabang,
                  idMakanan: makanan.datas[index].id,
                  jumlahStock: 0,
                ),
              );

              final item = makanan.datas[index];

              return Card(
                color: Colors.grey[200],
                elevation: 3,
                margin: EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        (index + 1).toString(),
                        style: TextStyle(fontSize: 9),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        flex: 2,
                        child: Text(
                          item.nama,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Rp ${item.harga}",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${filtered.jumlahStock}",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// final filtered
//                     = stock.datas
//                         .where((e) => e.idCabang == 2)
//                         .toList();

//                     if (filtered.isEmpty) {
//                       return Center(
//                         child: Text(
//                           "Tidak ada stock tersedia",
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       );
//                     }
