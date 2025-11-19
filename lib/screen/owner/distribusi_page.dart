import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/distribusi.dart';
import 'package:kerprak/widget/dll/card_cabang.dart';
import 'package:kerprak/widget/list/list_distribusi.dart';
import 'package:kerprak/widget/menu/dashboard_admin_menu.dart';
import 'package:provider/provider.dart';

class DistribusiPage extends StatefulWidget {
  const DistribusiPage({super.key});

  @override
  State<DistribusiPage> createState() => _DistribusiPageState();
}

class _DistribusiPageState extends State<DistribusiPage> {
  @override
  Widget build(BuildContext context) {
    var icon = [Icons.close_rounded, Icons.close_rounded];
    var nama = ["Dari", "Tujuan"];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardAdminMenu()),
            );
          },
          icon: Icon(Icons.arrow_back_ios_new_sharp),
        ),
        title: Text("Halaman Distribusi"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            padding: EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Consumer<Cabangs>(
                  builder: (context, value, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (context) {
                                  return PilihanCabang(value, 1);
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(20),
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(icon[0], size: 40),
                                  Text(nama[0]),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                          child: Icon(
                            Icons.keyboard_double_arrow_right,
                            size: 30,
                          ),
                        ),

                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (context) {
                                  return PilihanCabang(value, 1);
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(20),
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(icon[1], size: 40),
                                  Text(nama[1]),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                Container(
                  width: 250,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Divider(height: 3),
                ),
                Expanded(
                  child: ScrollbarTheme(
                    data: ScrollbarThemeData(
                      thumbVisibility: MaterialStateProperty.all(false),
                    ),
                    child: Column(children: [ListDistribusi()]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
