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
                            color: const Color(0xff6c63ff),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                mode != mode;
                              });
                            },
                            child: Text(
                              "rightButtonText",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // ---- CHART CONTAINER ----
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color.fromARGB(
                              255,
                              17,
                              49,
                              255,
                            ).withOpacity(0.2),
                            const Color.fromARGB(
                              255,
                              24,
                              77,
                              251,
                            ).withOpacity(0.05),
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
                          print(pendapatan);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              for (int a = 0; a < value.datas.length; a++)
                                if (value.datas[a].nama != "Gudang")
                                  FutureBuilder(
                                    future: Provider.of<Laporans>(
                                      context,
                                    ).getPendapatan(value.datas[a].id),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting)
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      // return Text("data");
                                      else
                                        return _bar(
                                          snapshot.data ?? 0,
                                          value.datas[a].nama,
                                          pendapatan ?? 0,
                                        );
                                    },
                                  ),
                            ],
                          );
                        },
                      ),
                      // child: Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   crossAxisAlignment: CrossAxisAlignment.end,
                      //   children: [
                      //     if (true) _bar(80, "Gudang"),
                      //     _bar(50, "Cipanas"),
                      //     _bar(80, "Cimacan"),
                      //     _bar(120, "GSP"),
                      //     _bar(100, "Balakang"),
                      //   ],
                      // ),
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
Widget _bar(double height, String nama_cabang, double pendapatan) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 20,
        height: (height / pendapatan) * 100 * 2,
        decoration: BoxDecoration(
          color: const Color(0xff6c63ff),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      Text(nama_cabang, style: TextStyle(fontSize: 10)),
    ],
  );
}
