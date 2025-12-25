import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/laporan.dart';
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
    final totalPendapatan = await Provider.of<Laporans>(
      context,
      listen: false,
    ).getTotalPendapatan();
    final totalPengeluaran = await Provider.of<Laporans>(
      context,
      listen: false,
    ).getTotalPengeluaran();

    if (!mounted) return;

    setState(() {
      pendapatan = totalPendapatan;
      pengeluaran = totalPengeluaran;
    });
  }

  double? pendapatan;
  double? pengeluaran;

  void gantiModeChart() {
    setState(() {
      mode = !mode;
    });
  }

  Future<void> _refreshData() async {
    await Provider.of<Cabangs>(context, listen: false).getCabang();
    pen(); // refresh pendapatan & pengeluaran
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
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 50,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    for (int a = 0; a < value.datas.length; a++)
                                      if (value.datas[a].nama != "Gudang" ||
                                          !mode)
                                        mode
                                            ? FutureBuilder(
                                                future:
                                                    Provider.of<Laporans>(
                                                      context,
                                                    ).getPendapatan(
                                                      value.datas[a].id,
                                                    ),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                      child: Text(""),
                                                    );
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
                                                future:
                                                    Provider.of<Laporans>(
                                                      context,
                                                    ).getPengeluaran(
                                                      value.datas[a].id,
                                                    ),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
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
                          ),
                          Container(
                            width: double.infinity,
                            height: mode ? 100 : 125,
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
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (int a = 0; a < value.datas.length; a++)
                                      if (value.datas[a].nama != "Gudang" ||
                                          !mode)
                                        mode
                                            ? FutureBuilder(
                                                future:
                                                    Provider.of<Laporans>(
                                                      context,
                                                    ).getPendapatan(
                                                      value.datas[a].id,
                                                    ),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                      child: Center(
                                                        child: Text(
                                                          "-",
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                          ),
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
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 100,
                                                          child: Text(
                                                            snapshot.data
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                },
                                              )
                                            : FutureBuilder(
                                                future:
                                                    Provider.of<Laporans>(
                                                      context,
                                                    ).getPengeluaran(
                                                      value.datas[a].id,
                                                    ),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                      child: Center(
                                                        child: Text(
                                                          "-",
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                          ),
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
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                          child: Text(
                                                            ":",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 100,
                                                          child: Text(
                                                            snapshot.data
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                            ),
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
                  SizedBox(height: 20),
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
          ),
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
