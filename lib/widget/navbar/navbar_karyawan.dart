import 'package:flutter/material.dart';
import 'package:kerprak/screen/karyawan/konsumsi_page.dart';
import 'package:kerprak/screen/karyawan/pengeluaran_page.dart';
import 'package:kerprak/screen/karyawan/penjualan_page.dart';

class NavbarKaryawan extends StatelessWidget {
  int x;
  final id_cab;
  NavbarKaryawan({super.key, required this.id_cab, required this.x});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: x < 0 ? 0 : x,
      backgroundColor: Color(0xFF111118),
      selectedItemColor: x < 0 ? Colors.grey[400] : Colors.blueAccent,
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
        BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Konsumsi"),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PenjualanPage(id_cabang: id_cab),
              ),
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
              MaterialPageRoute(
                builder: (context) => KonsumsiPage(id_cabang: id_cab!),
              ),
            );
            break;
        }
      },
    );
  }
}
