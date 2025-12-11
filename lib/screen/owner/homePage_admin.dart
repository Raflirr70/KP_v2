import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Cabangs>(context, listen: false).getCabang();
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
              margin: EdgeInsets.only(top: 0, left: 10, right: 10),
              padding: EdgeInsets.all(10),
              constraints: BoxConstraints(minHeight: 10, maxHeight: 270),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 175,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: 40,
                            color: Colors.amber,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: 3,
                            color: Colors.blue,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: 2,
                            color: Colors.red,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: 80,
                            color: Colors.green,
                            showTitle: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15, width: 150, child: Divider()),
                  Consumer<Cabangs>(
                    builder: (context, value, child) {
                      return Table(
                        // border: TableBorder.all(),
                        defaultColumnWidth: FixedColumnWidth(75),
                        children: [
                          TableRow(
                            children: [
                              legendItem(Colors.amber, value.datas[1].nama),
                              legendItem(Colors.red, value.datas[2].nama),
                            ],
                          ),
                          TableRow(
                            children: [
                              legendItem(Colors.blue, value.datas[3].nama),
                              legendItem(Colors.green, value.datas[4].nama),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
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
