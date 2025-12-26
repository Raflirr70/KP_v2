import 'package:flutter/material.dart';
import 'package:kerprak/widget/menu/LineChartPendapatanAll.dart';
import 'package:kerprak/widget/menu/LineChartPengeluaran14Hari.dart';
import 'package:kerprak/widget/navbar/appbar_admin.dart';

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppbarAdmin(),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _current = MonitoringType.pendapatan;
                      });
                    },
                    child: SizedBox(
                      height: 50,
                      child: Center(child: Text("Pendapatan")),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _current = MonitoringType.pengeluaran;
                      });
                    },
                    child: SizedBox(
                      height: 50,
                      child: Center(child: Text("Pengeluaran")),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _current = MonitoringType.makanan;
                      });
                    },
                    child: SizedBox(
                      height: 50,
                      child: Center(child: Text("Penjualan")),
                    ),
                  ),
                ),
              ],
            ),
            if (_current == MonitoringType.pendapatan) ...[
              Container(
                width: double.infinity,
                height: 200,
                child: Linechartpendapatanall(),
              ),
            ] else if (_current == MonitoringType.pengeluaran) ...[
              Container(
                width: double.infinity,
                height: 200,
                child: LineChartPengeluaran14Hari(),
              ),
            ] else if (_current == MonitoringType.makanan) ...[
              Container(
                width: double.infinity,
                height: 200,
                child: LineChartPengeluaran14Hari(),
              ),
            ] else ...[
              Container(
                width: double.infinity,
                height: 200,
                child: Linechartpendapatanall(),
              ),
            ],

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
