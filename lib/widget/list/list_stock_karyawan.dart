import 'package:flutter/material.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/stock.dart';
import 'package:provider/provider.dart';

class ListStockKaryawan extends StatelessWidget {
  final String? id_cabang;
  const ListStockKaryawan({super.key, required this.id_cabang});

  @override
  Widget build(BuildContext context) {
    if (id_cabang == null) {
      return Center(child: CircularProgressIndicator());
    }

    // Stream Makanan
    return StreamBuilder<List<Makanan>>(
      stream: context.read<Makanans>().streamMakanan(),
      builder: (context, makananSnap) {
        if (!makananSnap.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final listMakanan = makananSnap.data!;

        // Stream Stock berdasarkan cabang
        return StreamBuilder<List<Stock>>(
          stream: context.read<Stocks>().streamStockByIdCabang(id_cabang!),
          builder: (context, stockSnap) {
            if (!stockSnap.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final listStock = stockSnap.data!;

            return Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: listMakanan.length,
                itemBuilder: (context, index) {
                  final item = listMakanan[index];

                  final filtered = listStock.firstWhere(
                    (e) => e.idMakanan == item.id,
                    orElse: () => Stock(
                      id: "",
                      idCabang: id_cabang!,
                      idMakanan: item.id,
                      jumlahStock: 0,
                    ),
                  );

                  return InkWell(
                    onLongPress: () {
                      // TODO: penghapusan penjualan
                      // dan mengembalikan nilai/barang yang dijual ke stock
                    },
                    child: Card(
                      color: Colors.grey[200],
                      elevation: 3,
                      margin: EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
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
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
