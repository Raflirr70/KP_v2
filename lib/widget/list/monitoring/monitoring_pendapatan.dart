import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/penjualan.dart';
import 'package:kerprak/model/search.dart';
import 'package:kerprak/model/stock.dart';
import 'package:kerprak/widget/search/search_simple.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MonitoringPendapatan extends StatefulWidget {
  const MonitoringPendapatan({super.key});

  @override
  State<MonitoringPendapatan> createState() => _MonitoringPendapatanState();
}

class _MonitoringPendapatanState extends State<MonitoringPendapatan> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Search
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
              Text("Detail Penjualan"),
              Spacer(),
              // Expanded(
              //   child: SearchSimple(
              //     data: Penjualans().datas
              //         .expand((p) => p.detail.map((d) => d.nama_makanan))
              //         .toSet() // remove duplicates
              //         .toList(),
              //   ),
              // ),
            ],
          ),
        ),

        // List Penjualan
        Expanded(
          child: Consumer2<Penjualans, SearchProvider>(
            builder: (context, penjualans, search, child) {
              final nomorMap = {
                for (var i = 0; i < penjualans.datas.length; i++)
                  penjualans.datas[i]: i,
              };

              final filtered = penjualans.datas.where((penjualan) {
                return penjualan.detail.any(
                  (detail) => search.filtered.any(
                    (name) => detail.nama_makanan.toLowerCase().contains(
                      name.toLowerCase(),
                    ),
                  ),
                );
              }).toList();

              return ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  var p = filtered[index];
                  int nomorPenjualan = nomorMap[p]!;
                  return ExpandableCard(index: nomorPenjualan, penjualan: p);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// Widget card expandable
class ExpandableCard extends StatefulWidget {
  final int index;
  final dynamic penjualan;

  const ExpandableCard({
    super.key,
    required this.index,
    required this.penjualan,
  });

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
          ),
        ),
        constraints: BoxConstraints(minHeight: 73),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Pembelian Ke-${widget.index + 1}",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${widget.penjualan.jam!.hour.toString().padLeft(2, '0')}:${widget.penjualan.jam!.minute.toString().padLeft(2, '0')}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Rp ${NumberFormat("#,###", "id_ID").format(widget.penjualan.hitungTotal())}",
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ],
            ),

            if (isExpanded)
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.penjualan.detail.map<Widget>((detail) {
                    return Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            detail.nama_makanan,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Text(" : "),
                        SizedBox(
                          width: 30,
                          child: Text(
                            "${detail.jumlah}",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Text(
                          "( Rp ${NumberFormat("#,###", "id_ID").format(detail.total_harga)} )",
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
