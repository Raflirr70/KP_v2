import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kerprak/model/stock.dart';
import 'package:kerprak/screen/karyawan/konsumsi_page.dart';
import 'package:kerprak/screen/karyawan/pengeluaran_page.dart';
import 'package:kerprak/screen/karyawan/penjualan_page.dart';
import 'package:provider/provider.dart';

class HomepageKaryawan extends StatefulWidget {
  const HomepageKaryawan({super.key});

  @override
  State<HomepageKaryawan> createState() => _HomepageKaryawanState();
}

class _HomepageKaryawanState extends State<HomepageKaryawan> {
  final _user = FirebaseAuth.instance.currentUser;
  final _currentIndex = 1;
  bool _show_info = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50], // Lebih lembut dari grey[100]
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16), // atur radius sesukamu
            ),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blueAccent,
              title: Row(
                children: [
                  Row(
                    children: [
                      Icon(Icons.temple_buddhist_outlined),
                      SizedBox(width: 5),
                      Text(
                        "Cipanas",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(_user!.email!, style: TextStyle(fontSize: 10)),
                      Text(
                        "Karyawan",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 5),
                  InkWell(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: Icon(Icons.account_circle_rounded, size: 30),
                  ),
                ],
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.lightBlueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
        ),

        body: Column(
          children: [
            // =================== SUMMARY CARD ===================
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, -0.2),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: _show_info
                    ? Card(
                        key: ValueKey("summaryCard"),
                        shape: RoundedRectangleBorder(),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _summaryBox(
                                      "Pendapatan",
                                      "Rp 1.250.500",
                                      Colors.green,
                                      Icons.trending_up,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: _summaryBox(
                                      "Pengeluaran",
                                      "Rp 54.500",
                                      Colors.red,
                                      Icons.trending_down,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: _summaryBox(
                                      "Total",
                                      "Rp 973.000",
                                      Colors.blueAccent,
                                      Icons.account_balance_wallet,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: _summaryBox(
                                      "Penjualan",
                                      "67 Porsi",
                                      Colors.deepPurple,
                                      Icons.shopping_cart,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox.shrink(key: ValueKey("empty")),
              ),
            ),

            // ==================== LABEL ====================
            InkWell(
              onTap: () {
                setState(() => _show_info = !_show_info);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory, color: Colors.blueAccent),
                  SizedBox(width: 8),
                  Text(
                    "Stock Saat Ini",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.inventory, color: Colors.blueAccent),
                ],
              ),
            ),
            SizedBox(height: 12),

            // ==================== LIST VIEW ====================
            //   Expanded(
            //     child: Consumer<Stocks>(
            //       builder: (context, value, child) {
            //         final filtered;
            //         = value.datas
            //             .where((e) => e.cabang.id == 2)
            //             .toList();

            //         if (filtered.isEmpty) {
            //           return Center(
            //             child: Text(
            //               "Tidak ada stock tersedia",
            //               style: TextStyle(color: Colors.grey),
            //             ),
            //           );
            //         }

            //         return ListView.builder(
            //           padding: EdgeInsets.symmetric(horizontal: 16),
            //           itemCount: filtered.length,
            //           itemBuilder: (context, index) {
            //             final item = filtered[index];
            //             return Card(
            //               color: Colors.grey[200],
            //               elevation: 3,
            //               margin: EdgeInsets.only(bottom: 12),
            //               child: Padding(
            //                 padding: EdgeInsets.symmetric(
            //                   horizontal: 16,
            //                   vertical: 10,
            //                 ),
            //                 child: Row(
            //                   children: [
            //                     Text(
            //                       (index + 1).toString(),
            //                       style: TextStyle(fontSize: 9),
            //                     ),
            //                     SizedBox(width: 5),
            //                     Expanded(
            //                       flex: 2,
            //                       child: Text(
            //                         item.makanan.nama,
            //                         style: TextStyle(
            //                           fontSize: 12,
            //                           fontWeight: FontWeight.w600,
            //                         ),
            //                       ),
            //                     ),
            //                     Expanded(
            //                       child: Text(
            //                         "Rp ${item.makanan.harga}",
            //                         textAlign: TextAlign.end,
            //                         style: TextStyle(
            //                           fontSize: 10,
            //                           color: Colors.grey[700],
            //                         ),
            //                       ),
            //                     ),
            //                     SizedBox(width: 8),
            //                     Expanded(
            //                       child: Container(
            //                         padding: EdgeInsets.symmetric(vertical: 4),
            //                         decoration: BoxDecoration(
            //                           color: Colors.grey[300],
            //                           borderRadius: BorderRadius.circular(8),
            //                         ),
            //                         child: Text(
            //                           "${item.stock.toString()} / ${(item.stock + 7).toString()}",
            //                           textAlign: TextAlign.center,
            //                           style: TextStyle(
            //                             fontWeight: FontWeight.bold,

            //                             fontSize: 10,
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             );
            //           },
            //         );
            //       },
            //     ),
            //   ),
          ],
        ),

        // ================== NAV BAR ==================
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Color(0xFF111118),
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey[400],
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed, // Pastikan semua item terlihat
          elevation: 8,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "Penjualan",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: "Pengeluaran",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fastfood),
              label: "Konsumsi",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: "Laporan",
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PenjualanPage()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PengeluaranPage()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KonsumsiPage()),
                );
                break;
              case 3:
                // Navigasi ke Laporan jika ada
                break;
            }
          },
        ),
      ),
    );
  }

  // =================== WIDGET SUMMARY ===================
  Widget _summaryBox(String label, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28), // Tambah ikon
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 9,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // =================== MENU ITEM ===================
  Widget _menuItem({
    required String title,
    required IconData icon,
    required Color color,
    required Function onTap,
  }) {
    return InkWell(
      onTap: () => onTap(),
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
