import 'package:flutter/material.dart';
import 'package:kerprak/screen/karyawan/pengeluaran_page.dart';
import 'package:kerprak/screen/karyawan/penjualan_page.dart';

class HomepageKaryawan extends StatelessWidget {
  const HomepageKaryawan({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text("Dashboard Karyawan"),
        ),
        body: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              // ================= TOP SUMMARY CARD ===================
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _summaryBox("Penjualan", Colors.lightBlue),
                          SizedBox(width: 10),
                          _summaryBox("Pengeluaran", Colors.deepOrange),
                          SizedBox(width: 10),
                          _summaryBox("Konsumsi", Colors.green),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            flex: 2, // 2 bagian
                            child: _summaryBox("Menu", Colors.purple),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 1, // 1 bagian
                            child: _summaryBox("Laporan", Colors.indigo),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // =============== MAIN MENU GRID ==================
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 1.2,
                  children: [
                    _menuItem(
                      title: "Penjualan",
                      icon: Icons.shopping_cart,
                      color: Colors.blueAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PenjualanPage(),
                          ),
                        );
                      },
                    ),
                    _menuItem(
                      title: "Pengeluaran",
                      icon: Icons.account_balance_wallet,
                      color: Colors.redAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PengeluaranPage(),
                          ),
                        );
                      },
                    ),
                    _menuItem(
                      title: "Konsumsi",
                      icon: Icons.fastfood,
                      color: Colors.orange,
                      onTap: () {},
                    ),
                    _menuItem(
                      title: "Laporan",
                      icon: Icons.receipt_long,
                      color: Colors.green,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =================== WIDGET SUMMARY ===================
  Widget _summaryBox(String label, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
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
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(16),
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
