import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/jadwal.dart';
import 'package:kerprak/model/laporan.dart';
import 'package:kerprak/model/penggajian.dart';
import 'package:provider/provider.dart';

class LaporanHarian extends StatefulWidget {
  DateTime time;
  LaporanHarian({super.key, required this.time});

  @override
  State<LaporanHarian> createState() => _LaporanHarianState();

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
    required num value,
    required IconData icon,
  }) {
    final bool isNegative = value < 0;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: isNegative ? Colors.red.shade400 : Colors.green.shade600,
          ),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
          ),
          const SizedBox(height: 4),
          Text(
            "Rp ${value.abs()}",
            style: TextStyle(
              color: isNegative ? Colors.red.shade400 : Colors.green.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _LaporanHarianState extends State<LaporanHarian> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Cabangs>(context, listen: false).getCabang();
      Provider.of<Jadwals>(context, listen: false).getJadwal(widget.time);
    });
    pen();
  }

  void pen() async {
    final totalPendapatan = await Provider.of<Laporans>(
      context,
      listen: false,
    ).getTotalPendapatan(widget.time);
    final totalPengeluaran = await Provider.of<Laporans>(
      context,
      listen: false,
    ).getTotalPengeluaran(widget.time);

    if (!mounted) return;

    setState(() {
      pendapatan = totalPendapatan;
      pengeluaran = totalPengeluaran;
    });
  }

  @override
  void didUpdateWidget(covariant LaporanHarian oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.time != widget.time) {
      Provider.of<Jadwals>(context, listen: false).getJadwal(DateTime.now());

      pen(); // refresh pendapatan & pengeluaran
    }
  }

  double? pendapatan;
  double? pengeluaran;
  int gaji = 0;

  Future<void> _refreshData() async {
    await Provider.of<Cabangs>(context, listen: false).getCabang();
    pen(); // refresh pendapatan & pengeluaran
  }

  @override
  Widget build(BuildContext context) {
    print("pendapatan $pendapatan");
    print("pegeluaran $pengeluaran");
    print("time ${widget.time}");
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
                // Expanded(
                //   flex: 2,
                //   child: Card(
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: const [
                //         Icon(Icons.pie_chart, size: 56),
                //         SizedBox(height: 6),
                //         Text(
                //           "Diagram Penjualans",
                //           style: TextStyle(
                //             fontSize: 14,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(width: 8),

                // Statistik
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      LaporanHarian._infoCard(
                        icon: Icons.arrow_upward,
                        title: "Pendapatan",
                        value: pendapatan != null ? "Rp $pendapatan" : "Rp 0",
                        color: Colors.green,
                      ),
                      const SizedBox(height: 6),
                      LaporanHarian._infoCard(
                        icon: Icons.arrow_downward,
                        title: "Pengeluaran",
                        value: pengeluaran != null ? "Rp $pengeluaran" : "Rp 0",
                        color: Colors.red,
                      ),
                      const SizedBox(height: 6),
                      Consumer<Jadwals>(
                        builder: (context, value, child) {
                          gaji = 0;
                          for (int a = 0; a < value.datas.length; a++) {
                            gaji += value.datas[a].nominal;
                          }
                          return LaporanHarian._infoCard(
                            icon: Icons.arrow_downward,
                            title: "Penggajian",
                            value: "Rp $gaji",
                            color: Colors.deepOrange,
                          );
                        },
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
                // Expanded(
                //   child: Card(
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     child: Consumer<Cabangs>(
                //       builder: (context, vcabang, child) {
                //         return Padding(
                //           padding: EdgeInsets.all(12),
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(
                //                 "Detail Penjualan",
                //                 style: TextStyle(
                //                   fontWeight: FontWeight.bold,
                //                   fontSize: 10,
                //                 ),
                //               ),
                //               SizedBox(height: 8),
                //               for (int i = 0; i < vcabang.datas.length; i++)
                //                 Text(
                //                   "Cimacan : 23 porsi",
                //                   style: TextStyle(fontSize: 10),
                //                 ),
                //             ],
                //           ),
                //         );
                //       },
                //     ),
                //   ),
                // ),
                const SizedBox(width: 8),

                Expanded(
                  child: Card(
                    color:
                        ((pendapatan ?? 0) - ((pengeluaran ?? 0) + gaji))
                            .isNegative
                        ? Colors.red[100]
                        : Colors.green[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: LaporanHarian._summaryCard(
                      title: "Total Penjualan",
                      value: ((pendapatan ?? 0) - ((pengeluaran ?? 0) + gaji)),
                      icon: Icons.account_balance_wallet,
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
}
