import 'package:flutter/material.dart';

class LaporanHarian extends StatelessWidget {
  const LaporanHarian({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // ===== BAGIAN ATAS =====
          SizedBox(
            height: 175,
            child: Row(
              children: [
                // Diagram
                Expanded(
                  flex: 2,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.pie_chart, size: 56),
                        SizedBox(height: 6),
                        Text(
                          "Diagram Penjualan",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Statistik
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _infoCard(
                        icon: Icons.arrow_downward,
                        title: "Pendapatan",
                        value: "Rp 0",
                        color: Colors.green,
                      ),
                      const SizedBox(height: 6),
                      _infoCard(
                        icon: Icons.arrow_upward,
                        title: "Pengeluaran",
                        value: "Rp 0",
                        color: Colors.red,
                      ),
                      const SizedBox(height: 6),
                      _infoCard(
                        icon: Icons.account_balance_wallet,
                        title: "Penggajian",
                        value: "Rp 0",
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ===== BAGIAN BAWAH =====
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Detail Penjualan",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Cimacan : 23 porsi",
                            style: TextStyle(fontSize: 10),
                          ),
                          Text(
                            "Cipanas : 12 porsi",
                            style: TextStyle(fontSize: 10),
                          ),
                          Text("GSP : 9 porsi", style: TextStyle(fontSize: 10)),
                          Text(
                            "Balakang : 8 porsi",
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _summaryCard(
                      title: "Total Penjualan",
                      value: "Rp 0",
                      icon: Icons.shopping_cart,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== KARTU STATISTIK KECIL =====
  static Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== KARTU RINGKASAN =====
  static Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
          ),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }
}
