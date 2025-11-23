import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/penjualan.dart';
import 'package:kerprak/model/search.dart';
import 'package:kerprak/model/stock.dart';
import 'package:kerprak/widget/search/search_simple.dart';
import 'package:provider/provider.dart';

class MonitoringPendapatan extends StatefulWidget {
  const MonitoringPendapatan({super.key});

  @override
  State<MonitoringPendapatan> createState() => _MonitoringPendapatanState();
}

class _MonitoringPendapatanState extends State<MonitoringPendapatan> {
  @override
  Widget build(BuildContext context) {
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
                    data: Makanans().datas.map((e) => e.nama).toList(),
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
                horizontal: BorderSide(color: Colors.grey.shade300, width: 1),
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
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: Consumer<Penjualans>(
              builder: (context, value, child) {
                return ListView.builder(
                  itemCount: value.datas.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      // onTap: () {},
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      (index + 1).toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Spacer(),
                                    Text("Pukul  : "),
                                    Text(
                                      "${value.datas[index].jam!.hour.toString().padLeft(2, '0')}:${value.datas[index].jam!.minute.toString().padLeft(2, '0')}",
                                    ),
                                  ],
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
          ),
        ],
      ),
    );
  }
}
