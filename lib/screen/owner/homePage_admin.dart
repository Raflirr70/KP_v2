import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/laporan.dart';
import 'package:kerprak/widget/dll/legen_item.dart';
import 'package:kerprak/widget/menu/dashboard_admin_menu.dart';
import 'package:kerprak/widget/navbar/appbar_admin.dart';
import 'package:provider/provider.dart';

class HomepageAdmin extends StatefulWidget {
  final String nama;
  const HomepageAdmin({super.key, required this.nama});

  @override
  State<HomepageAdmin> createState() => _HomepageAdminState();
}

class _HomepageAdminState extends State<HomepageAdmin> {
  bool mode = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Cabangs>(context, listen: false).getCabang();
    });
    pen();
  }

  void pen() async {
    final total = await Provider.of<Laporans>(
      context,
      listen: false,
    ).getTotalPendapatan();

    if (!mounted) return;

    setState(() {
      pendapatan = total;
    });
  }

  double? pendapatan;

  void gantiModeChart() {
    setState(() {
      mode = !mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Lebih lembut dari grey[100]
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppbarAdmin(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mode ? "Pendapatan" : "Pengeluaran",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: mode
                                ? Color(0xff6c63ff)
                                : Color.fromARGB(255, 216, 106, 55),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                mode = !mode;
                              });
                            },
                            child: Text(
                              "mode",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // ---- CHART CONTAINER ----
                    Container(
                      height: 170,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: mode
                              ? [
                                  const Color.fromARGB(
                                    255,
                                    17,
                                    49,
                                    255,
                                  ).withOpacity(0.4),
                                  const Color.fromARGB(
                                    255,
                                    24,
                                    77,
                                    251,
                                  ).withOpacity(0.1),
                                ]
                              : [
                                  const Color.fromARGB(
                                    255,
                                    238,
                                    96,
                                    2,
                                  ).withOpacity(0.3),
                                  const Color.fromARGB(
                                    255,
                                    251,
                                    172,
                                    24,
                                  ).withOpacity(0.07),
                                ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      child: Consumer<Cabangs>(
                        builder: (context, value, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              for (int a = 0; a < value.datas.length; a++)
                                if (value.datas[a].nama != "Gudang" || !mode)
                                  FutureBuilder(
                                    future: Provider.of<Laporans>(
                                      context,
                                    ).getPendapatan(value.datas[a].id),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return mode
                                            ? _barPendapatan(
                                                snapshot.data ?? 1,
                                                value.datas[a].nama,
                                                pendapatan ?? 1,
                                              )
                                            : _barPengeluaran(
                                                snapshot.data ?? 1,
                                                value.datas[a].nama,
                                                pendapatan ?? 1,
                                              );
                                        ;
                                      }
                                    },
                                  ),
                            ],
                          );
                        },
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: mode
                              ? [
                                  const Color.fromARGB(
                                    255,
                                    17,
                                    49,
                                    255,
                                  ).withOpacity(0.3),
                                  const Color.fromARGB(
                                    255,
                                    24,
                                    77,
                                    251,
                                  ).withOpacity(0.07),
                                ]
                              : [
                                  const Color.fromARGB(
                                    255,
                                    238,
                                    96,
                                    2,
                                  ).withOpacity(0.3),
                                  const Color.fromARGB(
                                    255,
                                    251,
                                    172,
                                    24,
                                  ).withOpacity(0.07),
                                ],
                          // begin: Alignment.topCenter,
                          // end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      child: Consumer<Cabangs>(
                        builder: (context, value, child) {
                          print(pendapatan);
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int a = 0; a < value.datas.length; a++)
                                if (value.datas[a].nama != "Gudang")
                                  FutureBuilder(
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
                                  ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 30,
              width: 200,
              child: Divider(thickness: 4, radius: BorderRadius.circular(100)),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: DashboardAdminMenu(),
              ),
            ),
          ],
        ),
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
