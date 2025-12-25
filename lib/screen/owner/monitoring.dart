import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/laporan.dart';
import 'package:kerprak/widget/dll/legen_item.dart';
import 'package:kerprak/widget/menu/LineChartPendapatan14Hari.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class Monitoring extends StatefulWidget {
  const Monitoring({super.key});

  @override
  State<Monitoring> createState() => _MonitoringState();
}

Future<void> _loadData() async {
  await Future.delayed(Duration(milliseconds: 500));
  // Di sini bisa panggil API / Provider untuk refresh data
}

enum MonitoringType { keseluruhan, pendapatan, pengeluaran, makanan }

class _MonitoringState extends State<Monitoring> {
  MonitoringType _current = MonitoringType.keseluruhan; // default halaman
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: 300,
        shape: RoundedRectangleBorder(),
        child: ListView(
          padding: EdgeInsets.only(top: 10),
          children: [
            ListTile(
              title: Text("Semua"),
              onTap: () {
                setState(() => _current = MonitoringType.keseluruhan);
                Navigator.pop(context); // tutup drawer
              },
            ),
            ListTile(
              title: Text("Pendapatan"),
              onTap: () {
                setState(() => _current = MonitoringType.pendapatan);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Pengeluaran"),
              onTap: () {
                setState(() => _current = MonitoringType.pengeluaran);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Makanan"),
              onTap: () {
                setState(() => _current = MonitoringType.makanan);
                Navigator.pop(context);
              },
            ),
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
              width: double.infinity,
              height: 300,
              child: Consumer<Cabangs>(
                builder: (context, value, child) {
                  return Consumer<Cabangs>(
                    builder: (context, value, child) {
                      // sesuaikan
                      return LineChartPendapatan14Hari();
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<void>(
                future: _loadData(), // fungsi Future untuk load data
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    ); // loading
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Terjadi kesalahan: ${snapshot.error}"),
                    );
                  } else {
                    // Data sudah siap, tampilkan sesuai _current
                    // switch (_current) {
                    //   case MonitoringType.keseluruhan:
                    //     return MonitoringKeseluruhan();
                    //   case MonitoringType.pendapatan:
                    //     return MonitoringPendapatan();
                    //   case MonitoringType.pengeluaran:
                    //     return MonitoringPengeluaran();
                    //   case MonitoringType.makanan:
                    //     return MonitoringMakanan();
                    // }
                  }
                  return Center(
                    child: Text("Pilih menu monitoring dari drawer"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatShort(int value) {
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1)}M';
  } else if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(0)}k';
  } else {
    return value.toString();
  }
}
