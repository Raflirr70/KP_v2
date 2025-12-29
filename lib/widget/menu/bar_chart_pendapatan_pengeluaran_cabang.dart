import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/laporan.dart';
import 'package:provider/provider.dart';

class BarChartPendapatanPengeluaranCabang extends StatelessWidget {
  DateTime time;
  BarChartPendapatanPengeluaranCabang({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    final cabangs = context.watch<Cabangs>().datas;

    if (cabangs.isEmpty) {
      return const Center(child: Text("Tidak ada data cabang"));
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _loadData(context, cabangs),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 190,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Tidak ada data laporan"));
        }

        return _buildChart(snapshot.data!);
      },
    );
  }

  // ================= LOAD DATA =================
  Future<List<Map<String, dynamic>>> _loadData(
    BuildContext context,
    List<Cabang> cabangs,
  ) async {
    final laporan = context.read<Laporans>();
    final List<Map<String, dynamic>> result = [];

    for (final c in cabangs) {
      if (c.nama == "Gudang") continue;

      final pendapatan = await laporan.getPendapatanWaktu(c.id, time);
      final pengeluaran = await laporan.getPendapatanWaktu(c.id, time);

      print("${c.id} dengan tanggal : $time");
      // final pengeluaran = await laporan.getPengeluaranWaktu(c.id, "hari");

      result.add({
        "nama": c.nama,
        "pendapatan": pendapatan > 0 ? pendapatan : 0.0,
        "pengeluaran": pengeluaran > 0 ? pengeluaran : 0.0,
      });
    }

    return result;
  }

  // ================= BUILD CHART =================
  Widget _buildChart(List<Map<String, dynamic>> data) {
    final rawMax = data
        .map((e) => max(e["pendapatan"], e["pengeluaran"]))
        .reduce(max);

    final maxY = max(1.0, (rawMax * 1.25).ceilToDouble());
    final interval = max(1.0, maxY / 4);

    return Container(
      height: 190,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xff6c63ff).withOpacity(0.25),
            const Color(0xff6c63ff).withOpacity(0.05),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          maxY: maxY,
          alignment: BarChartAlignment.spaceAround,
          barGroups: _buildBars(data),

          // ===== GRID =====
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: interval,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: Colors.white.withOpacity(0.3), strokeWidth: 1),
          ),

          // ===== BORDER =====
          borderData: FlBorderData(show: false),

          // ===== TITLES =====
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: interval,
                reservedSize: 36,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 9, color: Colors.black54),
                ),
              ),
            ),

            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= data.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      data[i]["nama"],
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // ===== TOUCH =====
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipPadding: const EdgeInsets.all(8),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final label = rodIndex == 0 ? "Pendapatan" : "Pengeluaran";
                return BarTooltipItem(
                  "$label\n${rod.toY.toInt()}",
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ================= BAR GROUP =================
  List<BarChartGroupData> _buildBars(List<Map<String, dynamic>> data) {
    return List.generate(data.length, (i) {
      final d = data[i];

      return BarChartGroupData(
        x: i,
        barsSpace: 6,
        barRods: [
          BarChartRodData(
            toY: (d["pendapatan"] as num).toDouble(),
            width: 12,
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: [Color(0xff6c63ff), Color(0xff8f88ff)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          BarChartRodData(
            toY: (d["pengeluaran"] as num).toDouble(),
            width: 12,
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: [Color(0xfff39c12), Color(0xffffc048)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ],
      );
    });
  }
}
