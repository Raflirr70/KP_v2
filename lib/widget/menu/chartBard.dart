import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/laporan.dart';
import 'package:provider/provider.dart';

class Chartbard extends StatelessWidget {
  double pendapatan, pengeluaran;
  bool mode;
  Chartbard({
    super.key,
    required this.pendapatan,
    required this.pengeluaran,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    // ---- CHART CONTAINER ----
    return Container(
      height: 170,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: mode
              ? [
                  const Color.fromARGB(255, 17, 49, 255).withOpacity(0.4),
                  const Color.fromARGB(255, 24, 77, 251).withOpacity(0.1),
                ]
              : [
                  const Color.fromARGB(255, 238, 96, 2).withOpacity(0.3),
                  const Color.fromARGB(255, 251, 172, 24).withOpacity(0.07),
                ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Consumer<Cabangs>(
        builder: (context, value, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (int a = 0; a < value.datas.length; a++)
                if (value.datas[a].nama != "Gudang" || !mode)
                  mode
                      ? FutureBuilder(
                          future: Provider.of<Laporans>(
                            context,
                          ).getPendapatan(value.datas[a].id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: Text(""));
                            } else {
                              return _barPendapatan(
                                snapshot.data ?? 1,
                                value.datas[a].nama,
                                pendapatan ?? 1,
                              );
                            }
                          },
                        )
                      : FutureBuilder(
                          future: Provider.of<Laporans>(
                            context,
                          ).getPengeluaran(value.datas[a].id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return _barPengeluaran(
                                snapshot.data ?? 1,
                                value.datas[a].nama,
                                pengeluaran ?? 1,
                              );
                            }
                          },
                        ),
            ],
          );
        },
      ),
    );
  }
}

// ---------- BAR ITEM ----------
Widget _barPendapatan(double height, String namaCabang, double pendapatan) {
  final safeTotal = pendapatan <= 0 ? 1 : pendapatan;
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 20,
        height: (height / safeTotal) * 100,
        // height: 100,
        decoration: BoxDecoration(
          color: const Color(0xff6c63ff),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      Text(namaCabang, style: TextStyle(fontSize: 10)),
    ],
  );
}

Widget _barPengeluaran(double height, String namaCabang, double pendapatan) {
  final safeTotal = pendapatan <= 0 ? 1 : pendapatan;
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 20,
        height: (height / safeTotal) * 100,
        // height: 100,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 240, 146, 38),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      Text(namaCabang, style: TextStyle(fontSize: 10)),
    ],
  );
}
