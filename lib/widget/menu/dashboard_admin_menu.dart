import 'package:flutter/material.dart';
import 'package:kerprak/model/menu_dasboard_admin.dart';
import 'package:kerprak/screen/owner/daftar_gaji_karyawan.dart';
import 'package:kerprak/screen/owner/daftar_karyawan.dart';
import 'package:kerprak/screen/owner/daftar_makanan.dart';
import 'package:kerprak/screen/owner/daftar_pengeluaran.dart';
import 'package:kerprak/screen/owner/daftar_stock.dart';
import 'package:kerprak/screen/owner/distribusi_page.dart';
import 'package:kerprak/screen/owner/monitoring.dart';
import 'package:kerprak/screen/owner/penjadwalan_page.dart';

class DashboardAdminMenu extends StatelessWidget {
  const DashboardAdminMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: List.generate(MenuDasboardAdmin.nama.length, (a) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(0),
            ),
            onPressed: () {
              if (a == 0) {
                // Monitoring
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Monitoring()),
                // );
              } else if (a == 1) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Center(
                        child: Icon(Icons.restaurant_menu, size: 40),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 250,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    10,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DaftarMakanan(),
                                  ),
                                );
                              },
                              child: Text("Makanan"),
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: 250,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    10,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DaftarStock(),
                                  ),
                                );
                              },
                              child: Text("Stock"),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else if (a == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DistribusiPage()),
                );
              } else if (a == 3) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Center(child: Icon(Icons.attach_money, size: 40)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 250,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    10,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DaftarPengeluaran(),
                                  ),
                                );
                              },
                              child: Text("Oprasional"),
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: 250,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    10,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DaftarGajiKaryawan(),
                                  ),
                                );
                              },
                              child: Text("Gaji Karyawan"),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else if (a == 4) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PenjadwalanPage()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DaftarKaryawan()),
                );
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(MenuDasboardAdmin.logo[a], size: 40),
                Text(MenuDasboardAdmin.nama[a], style: TextStyle(fontSize: 13)),
              ],
            ),
          );
        }),
      ),
    );
  }
}
