import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:kerprak/model/laporan.dart';
import 'package:kerprak/screen/owner/monitoring.dart';

class Linechartpendapatanall extends StatelessWidget {
  const Linechartpendapatanall({super.key});

  static const int totalHari = 365;
  static const double widthPerHari = 25;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<double>>>(
      future: Future.wait([
        context.read<Laporans>().getPendapatanHarianM(jumlahHari: totalHari),
        context.read<Laporans>().getPengeluaranHarianM(jumlahHari: totalHari),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("Tidak ada data"));
        }

        final pendapatan = snapshot.data![0];
        final pengeluaran = snapshot.data![1];

        return _buildChart(context, pendapatan, pengeluaran);
      },
    );
  }

  Widget _buildChart(
    BuildContext context,
    List<double> pendapatan,
    List<double> pengeluaran,
  ) {
    final now = DateTime.now();

    final days = List.generate(
      totalHari,
      (i) => now.subtract(Duration(days: totalHari - 1 - i)),
    );

    final maxValue = [...pendapatan, ...pengeluaran].reduce(max);
    final double batas = (maxValue * 1.2).ceilToDouble();

    final double chartWidth = totalHari * widthPerHari;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _legend(),
          Expanded(
            child: Row(
              children: [
                _leftAxis(batas),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(right: 20),
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: SizedBox(
                      width: chartWidth,
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: totalHari - 1,
                          minY: 0,
                          maxY: batas,

                          /// Tooltip
                          lineTouchData: LineTouchData(
                            handleBuiltInTouches: true,
                            getTouchedSpotIndicator: (barData, spotIndexes) {
                              return spotIndexes.map((index) {
                                return TouchedSpotIndicatorData(
                                  FlLine(
                                    color: barData.color ?? Colors.grey,
                                    strokeWidth: 0.5,
                                    dashArray: [4, 4],
                                  ),
                                  FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, barData, index) {
                                          return FlDotCirclePainter(
                                            radius: 3,
                                            color:
                                                barData.color ?? Colors.white,
                                            strokeWidth: 1,
                                            strokeColor: Colors.white,
                                          );
                                        },
                                  ),
                                );
                              }).toList();
                            },

                            touchTooltipData: LineTouchTooltipData(
                              tooltipMargin: -20,
                              tooltipPadding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              getTooltipItems: (spots) {
                                return spots.map((spot) {
                                  return LineTooltipItem(
                                    formatShort((spot.y * 1000).toInt()),
                                    TextStyle(
                                      color: spot.bar.color ?? Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),

                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 2,
                                reservedSize: 34,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index < 0 || index >= days.length) {
                                    return const SizedBox.shrink();
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Column(
                                      children: [
                                        Text(
                                          DateFormat('MMM').format(days[index]),
                                          style: const TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('dd').format(days[index]),
                                          style: TextStyle(
                                            fontSize: 8,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: batas / 5,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.grey.withOpacity(0.15),
                              strokeWidth: 1,
                            ),
                          ),

                          borderData: FlBorderData(show: false),

                          lineBarsData: [
                            ///  Pendapatan
                            LineChartBarData(
                              spots: List.generate(
                                pendapatan.length,
                                (i) => FlSpot(i.toDouble(), pendapatan[i]),
                              ),
                              // isCurved: true,
                              curveSmoothness: 0.3,
                              color: Colors.blueAccent,
                              barWidth: 3,
                              dotData: FlDotData(show: false),
                            ),

                            ///  Pengeluaran
                            LineChartBarData(
                              spots: List.generate(
                                pengeluaran.length,
                                (i) => FlSpot(i.toDouble(), pengeluaran[i]),
                              ),
                              // isCurved: true,
                              curveSmoothness: 0.3,
                              color: Colors.orange,
                              barWidth: 3,
                              dotData: FlDotData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// WIDGET AXIS KIRI (TIDAK SCROLL)
  Widget _leftAxis(double batas) {
    return Container(
      width: 40,
      padding: const EdgeInsets.only(left: 6, right: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(6, (i) {
          final value = batas - (batas / 5 * i);
          if (value <= 0) return const SizedBox.shrink();

          return Text(
            "${value.toInt()}k",
            style: TextStyle(fontSize: 9, color: Colors.grey[600]),
          );
        }),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 3, // mirip garis chart
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

Widget _legend() {
  return Padding(
    padding: const EdgeInsets.only(top: 6, bottom: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _LegendItem(color: Colors.blueAccent, text: "Pendapatan"),
        SizedBox(width: 16),
        _LegendItem(color: Colors.orange, text: "Pengeluaran"),
      ],
    ),
  );
}
