import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/pengeluaran.dart';
import 'package:kerprak/model/penjualan.dart';
import 'package:kerprak/model/search.dart';
import 'package:kerprak/model/stock.dart';
import 'package:kerprak/widget/search/search_simple.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MonitoringPengeluaran extends StatefulWidget {
  const MonitoringPengeluaran({super.key});

  @override
  State<MonitoringPengeluaran> createState() => _MonitoringPengeluaranState();
}

class _MonitoringPengeluaranState extends State<MonitoringPengeluaran> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<Pengeluarans, Cabangs, SearchProvider>(
      builder: (context, pengeluaran, cabang, search, child) {
        return Column(
          children: [
            // ============== SEARCH HEADER ===================
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border.symmetric(
                  horizontal: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Text("Monitoring Pengeluaran"),
                  SizedBox(width: 12),
                  Expanded(
                    child: SearchSimple(
                      data: pengeluaran.datas
                          .map((e) => e.nama_pengeluaran)
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),

            // ============= LIST PENGELUARAN PER CABANG =============
            Expanded(
              child: ListView.builder(
                itemCount: cabang.datas.length,
                itemBuilder: (context, cabIndex) {
                  var cab = cabang.datas[cabIndex];

                  // Pengeluaran khusus untuk cabang ini
                  var listPengeluaran = pengeluaran.datas
                      .where(
                        (p) =>
                            p.id_cabang == cab.id &&
                            search.filtered.contains(p.nama_pengeluaran),
                      )
                      .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ------- HEADER CABANG --------
                      Container(
                        width: double.infinity,
                        color: Colors.blue.shade50,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          cab.nama,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Jika tidak ada pengeluaran
                      if (listPengeluaran.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            "Tidak ada pengeluaran",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),

                      // ------- LIST PENGELUARAN --------
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: listPengeluaran.length,
                        itemBuilder: (context, i) {
                          var p = listPengeluaran[i];

                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: Text(p.nama_pengeluaran),
                                ),
                                SizedBox(width: 20, child: Text(" : ")),
                                SizedBox(
                                  width: 30,
                                  child: Text(
                                    p.jumlah_unit.toString(),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsGeometry.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: Text(p.jenis_satuan),
                                ),
                                Expanded(
                                  child: Text(
                                    "Rp ${NumberFormat('#,###', 'id_ID').format(p.total_harga)}",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                          child: Text(
                            "Rp ${listPengeluaran[cabIndex].total_harga} ",
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
