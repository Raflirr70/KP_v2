import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kerprak/model/jadwal.dart';
import 'package:kerprak/model/laporan.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/penggajian.dart';
import 'package:kerprak/model/stock.dart';
import 'package:kerprak/model/user.dart';
import 'package:kerprak/screen/karyawan/konsumsi_page.dart';
import 'package:kerprak/screen/karyawan/pengeluaran_page.dart';
import 'package:kerprak/screen/karyawan/penjualan_page.dart';
import 'package:kerprak/widget/list/list_stock_karyawan.dart';
import 'package:provider/provider.dart';

class HomepageKaryawan extends StatefulWidget {
  final id_user;
  const HomepageKaryawan({super.key, required this.id_user});

  @override
  State<HomepageKaryawan> createState() => _HomepageKaryawanState();
}

class _HomepageKaryawanState extends State<HomepageKaryawan> {
  String? id_cab;
  final _user = FirebaseAuth.instance.currentUser;
  final _currentIndex = 1;
  bool _show_info = true;
  TextEditingController _searchCtrl = TextEditingController();
  bool _akunBelumJadwal = false;
  bool _loading = false;

  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    // 1. Ambil jadwal untuk user ini
    final jadwalsProvider = Provider.of<Jadwals>(context, listen: false);
    await jadwalsProvider.getJadwal();

    // 2. Ambil jadwal user berdasarkan id_user
    Jadwal? jadwalUser;

    try {
      jadwalUser = jadwalsProvider.datas.firstWhere(
        (j) => j.id_user == widget.id_user,
      );
    } catch (e) {
      jadwalUser = null; // kalau tidak ada, jadwalUser tetap null
    }
    if (jadwalUser != null) {
      final idCabang = jadwalUser.id_cabang;
      setState(() {
        id_cab = idCabang;
      });
      final laporanProvider = Provider.of<Laporans>(context, listen: false);
      await laporanProvider.getData(idCabang);
      await Future.delayed(Duration(milliseconds: 200));
      await laporanProvider.checkAndCreateLaporan(idCabang);
    } else {
      setState(() {
        _akunBelumJadwal = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    if (_akunBelumJadwal) {
      return Scaffold(
        backgroundColor: Colors.grey,
        body: Center(
          child: Card(
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Perhatian",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text("Akun belum dapat jadwal."),
                  Text("Harap Lapor Ke Owner"),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                      child: Text("OK"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    // return Scaffold(
    //   body: Consumer<Laporans>(
    //     builder: (context, value, child) {
    //       return Text(
    //         "Jumlah Laporan : ${value.datas.length}",
    //         style: TextStyle(fontWeight: FontWeight.bold),
    //       );
    //     },
    //   ),
    // );
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
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

            InkWell(
              onTap: () {
                setState(() => _show_info = !_show_info);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory, color: Colors.blueAccent),
                  SizedBox(width: 8),
                  Consumer<Laporans>(
                    builder: (context, value, child) {
                      return Text(
                        "Stock Saat Ini ${value.datas.length}",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.grey[800],
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.inventory, color: Colors.blueAccent),
                ],
              ),
            ),
            SizedBox(height: 12),

            // ==================== LIST VIEW ====================
            ListStockKaryawan(id_cabang: id_cab),
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
