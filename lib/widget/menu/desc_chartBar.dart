import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/laporan.dart';
import 'package:provider/provider.dart';

class DescChartbar extends StatelessWidget {
  bool mode;
  DescChartbar({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: mode ? 100 : 125,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: mode
              ? [
                  const Color.fromARGB(255, 17, 49, 255).withOpacity(0.3),
                  const Color.fromARGB(255, 24, 77, 251).withOpacity(0.07),
                ]
              : [
                  const Color.fromARGB(255, 238, 96, 2).withOpacity(0.3),
                  const Color.fromARGB(255, 251, 172, 24).withOpacity(0.07),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Consumer<Cabangs>(
        builder: (context, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                              return Center(
                                child: Center(
                                  child: Text(
                                    "-",
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                              );
                            } else {
                              return Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      value.datas[a].nama,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                    child: Text(
                                      ":",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      snapshot.data.toString(),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
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
                              return Center(
                                child: Center(
                                  child: Text(
                                    "-",
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                              );
                            } else {
                              return Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      value.datas[a].nama,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                    child: Text(
                                      ":",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      snapshot.data.toString(),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
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
