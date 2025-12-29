import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kerprak/model/laporan.dart';
import 'package:kerprak/screen/owner/detail_laporan.dart';
import 'package:provider/provider.dart';
import 'package:kerprak/model/konsumsi.dart';

class ListLaporanWidget extends StatelessWidget {
  const ListLaporanWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<Laporans>(
      builder: (context, laporans, _) {
        if (laporans.datas.isEmpty) {
          return const Center(child: Text("Belum ada laporan"));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: laporans.datas.length,
          itemBuilder: (context, index) {
            final laporan = laporans.datas[index];
            final tanggal = laporan.tanggal != null
                ? DateFormat('dd MMM yyyy').format(laporan.tanggal!)
                : '-';
            final pendapatan = int.tryParse(laporan.id_penjualan ?? "0") ?? 0;
            final pengeluaran =
                int.tryParse(laporan.id_pengeluaran ?? "0") ?? 0;
            final keuntungan = pendapatan - pengeluaran;
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailLaporan(laporan: laporan),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "📅 Laporan $tanggal",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _rowItem("Pendapatan", pendapatan, Colors.green),
                      _rowItem("Pengeluaran", pengeluaran, Colors.red),
                      const Divider(),
                      _rowItem(
                        "Keuntungan",
                        keuntungan,
                        keuntungan >= 0 ? Colors.blue : Colors.red,
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _rowItem(String title, int value, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            "Rp ${NumberFormat('#,###', 'id_ID').format(value)}",
            style: TextStyle(
              color: color,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
