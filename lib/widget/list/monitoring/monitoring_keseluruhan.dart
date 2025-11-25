import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/laporan.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/search.dart';
import 'package:kerprak/model/stock.dart';
import 'package:kerprak/widget/search/search_simple.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MonitoringKeseluruhan extends StatefulWidget {
  const MonitoringKeseluruhan({super.key});

  @override
  State<MonitoringKeseluruhan> createState() => _MonitoringKeseluruhanState();
}

class _MonitoringKeseluruhanState extends State<MonitoringKeseluruhan> {
  String selectedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.symmetric(
                horizontal: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            width: double.infinity,
            child: Text("Detail Laporan"),
          ),
          Expanded(
            child: Consumer<Laporans>(
              builder: (context, provider, child) {
                // Filter laporan berdasarkan tanggal
                var filtered = provider.datas.where((lap) {
                  if (lap.tanggal == null) return false;
                  return DateFormat('dd-MM-yyyy').format(lap.tanggal!) ==
                      selectedDate;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      "Tidak ada laporan untuk tanggal ini",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  );
                }

                var lap = filtered.first;

                return ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    // ============== STATUS LAPORAN ==============
                    Text(
                      "Status: ${lap.status == true ? "Sudah Tutup" : "Belum Tutup"}",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 12),

                    // ============== TOTAL PENDAPATAN ==============
                    Text(
                      "Total Pendapatan: Rp ${lap.total_pendapatan ?? 0}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                    SizedBox(height: 8),

                    // ============== TOTAL PENGELUARAN ==============
                    Text(
                      "Total Pengeluaran: Rp ${lap.total_pengeluaran ?? 0}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade700,
                      ),
                    ),
                    SizedBox(height: 20),

                    Divider(),

                    // ============== DAFTAR KARYAWAN ==============
                    Text(
                      "Karyawan:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),

                    if (lap.Karyawan != null)
                      ...lap.Karyawan!.map(
                        (k) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text("- $k"),
                        ),
                      ),

                    SizedBox(height: 20),
                    Divider(),

                    // // ============== DETAIL PENJUALAN ==============
                    // Text(
                    //   "Detail Penjualan:",
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // ...lap.penjualan.map((p) {
                    //   return Padding(
                    //     padding: const EdgeInsets.only(top: 6),
                    //     child: Text(
                    //       "${p.nama_makanan} : ${p.jumlah} pcs - Rp ${p.total_harga}",
                    //     ),
                    //   );
                    // }),

                    // SizedBox(height: 20),
                    // Divider(),

                    // // ============== DETAIL PENGELUARAN ==============
                    // Text(
                    //   "Detail Pengeluaran:",
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // ...lap.pengeluaran.map((p) {
                    //   return Padding(
                    //     padding: const EdgeInsets.only(top: 6),
                    //     child: Text(
                    //       "${p.nama_pengeluaran} : ${p.jumlah_unit} ${p.jenis_satuan} - Rp ${p.total_harga}",
                    //     ),
                    //   );
                    // }),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
