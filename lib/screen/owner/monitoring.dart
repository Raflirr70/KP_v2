import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/widget/dll/legen_item.dart';
import 'package:kerprak/widget/list/monitoring/monitoring_makanan.dart';
import 'package:kerprak/widget/list/monitoring/monitoring_pendapatan.dart';
import 'package:provider/provider.dart';

class Monitoring extends StatefulWidget {
  const Monitoring({super.key});

  @override
  State<Monitoring> createState() => _MonitoringState();
}

class _MonitoringState extends State<Monitoring> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: 300,
        shape: RoundedRectangleBorder(),
        child: ListView(
          padding: EdgeInsets.only(top: 10),
          children: [
            ListTile(title: Text("Semua"), onTap: () {}),
            ListTile(title: Text("Pendapatan"), onTap: () {}),
            ListTile(title: Text("Pengeluaran"), onTap: () {}),
            ListTile(title: Text("Makanan"), onTap: () {}),
          ],
        ),
      ),

      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        // title: Text("Monitoring"),
        leading: IconButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(icon: Icon(Icons.access_time_rounded), onPressed: () {}),
          PopupMenuButton<String>(
            color: Colors.blueAccent,
            icon: Icon(Icons.calendar_today), // ikon kalender
            onSelected: (value) {
              // Aksi ketika memilih salah satu menu
              if (value == "hari") {
                print("Filter: Hari");
                // TODO: implementasi filter harian
              } else if (value == "minggu") {
                print("Filter: Minggu");
                // TODO: implementasi filter mingguan
              } else if (value == "bulan") {
                print("Filter: Bulan");
                // TODO: implementasi filter bulanan
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "hari",
                child: Row(
                  children: [
                    Text("Hari"),
                    Spacer(),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "minggu",
                child: Row(
                  children: [Text("Minggu"), Spacer(), Icon(Icons.date_range)],
                ),
              ),
              PopupMenuItem(
                value: "bulan",
                child: Row(
                  children: [
                    Text("Bulan"),
                    Spacer(),
                    Icon(Icons.calendar_month),
                  ],
                ),
              ),
            ],
          ),

          // Tombol di kanan untuk membuka drawer kiri
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () =>
                  Scaffold.of(context).openDrawer(), // <-- drawer kiri
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 0, left: 10, right: 10),
              padding: EdgeInsets.all(10),
              constraints: BoxConstraints(minHeight: 10, maxHeight: 270),
              width: double.infinity,
              height: 230,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.hardEdge,
              child: Consumer<Cabangs>(
                builder: (context, value, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 160,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: 40,
                                color: Colors.amber,
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                value: 3,
                                color: Colors.blue,
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                value: 2,
                                color: Colors.red,
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                value: 80,
                                color: Colors.green,
                                showTitle: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15, width: 150, child: Divider()),
                      Table(
                        defaultColumnWidth: FixedColumnWidth(75),
                        children: [
                          TableRow(
                            children: [
                              legendItem(Colors.amber, value.datas[1].nama),
                              legendItem(Colors.red, value.datas[2].nama),
                            ],
                          ),
                          TableRow(
                            children: [
                              legendItem(Colors.blue, value.datas[3].nama),
                              legendItem(Colors.green, value.datas[4].nama),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(child: MonitoringPendapatan()),
          ],
        ),
      ),
    );
  }
}
