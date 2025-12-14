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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Laporans>(context, listen: false).getAllData();
    });
  }

  double? pendapatan;
  // Future<void> getPendapatan(String id_cabang){
  //   setState(() async{
  //     pendapatan = await Provider.of<Laporans>(context).getPendapatan(id_cabang);
  //   });
  // }

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
                              "title",
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
                              // onTapMode();
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
                      height: 300,
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
                      child: Consumer2<Cabangs, Laporans>(
                        builder: (context, cabang, laporan, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              for (int a = 0; a < cabang.datas.length; a++)
                                if (laporan.datas
                                    .where(
                                      (l) => l.id_cabang == cabang.datas[a].id,
                                    )
                                    .isNotEmpty)
                                  _bar(
                                    getPendapatan(cabang.datas[a].id),
                                    cabang.datas[a].nama,
                                  ),
                              // _bar(80, cabang.datas[1].nama),
                              // _bar(80, cabang.datas[2].nama),
                              // _bar(80, cabang.datas[3].nama),
                              // _bar(80, cabang.datas[4].nama),
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
Widget _bar(double height, String nama_cabang) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 20,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xff6c63ff),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      Text(nama_cabang, style: TextStyle(fontSize: 10)),
    ],
  );
}
