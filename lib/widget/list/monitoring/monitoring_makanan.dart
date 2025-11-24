import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/search.dart';
import 'package:kerprak/model/stock.dart';
import 'package:kerprak/widget/search/search_simple.dart';
import 'package:provider/provider.dart';

class MonitoringMakanan extends StatefulWidget {
  const MonitoringMakanan({super.key});

  @override
  State<MonitoringMakanan> createState() => _MonitoringMakananState();
}

class _MonitoringMakananState extends State<MonitoringMakanan> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<Makanans, Stocks>(
      builder: (context, vm, vs, child) {
        return Expanded(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text("Detail Makanan"),
                    Spacer(),
                    Expanded(
                      child: SearchSimple(
                        data: vm.datas.map((e) => e.nama).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
                child: Consumer<Cabangs>(
                  builder: (context, value, child) {
                    return Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              "Makanan",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        for (int a = 0; a < value.datas.length; a++)
                          _buildHeaderCell(value.datas[a].nama),
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                child: Consumer<SearchProvider>(
                  builder: (context, s, child) {
                    return ListView.builder(
                      itemCount: s.filtered.length,
                      itemBuilder: (context, index) {
                        // Nama hasil filter
                        var nama = s.filtered[index];

                        // Mencari user yang nama-nya sama
                        var makanan = vs.datas.firstWhere(
                          (u) => u.makanan.nama == nama,
                        );

                        return InkWell(
                          onTap: () {},
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 16),
                                    child: Text(
                                      makanan.makanan.nama,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),

                                for (int a = 0; a < 5; a++)
                                  _buildDataCell(
                                    vs
                                        .getJumlah(a, makanan.makanan.id)
                                        .toString(),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderCell(String text) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: Colors.grey.shade300, width: 0.5),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: Colors.grey.shade200, width: 0.5),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
