import 'package:flutter/material.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/penjualan.dart';
import 'package:provider/provider.dart';

class GrafikPenjualan extends StatefulWidget {
  final DateTime time;
  const GrafikPenjualan({super.key, required this.time});

  @override
  State<GrafikPenjualan> createState() => _GrafikPenjualanState();
}

class _GrafikPenjualanState extends State<GrafikPenjualan> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Makanans>().getMakanan();
      context.read<Penjualans>().getPenjualanByHari(hari: widget.time);
    });
  }

  /// 🔥 Hitung total porsi per makanan
  Map<String, int> _hitungPorsi(List<Penjualan> penjualans) {
    final Map<String, int> hasil = {};

    for (var p in penjualans) {
      for (var d in p.detail) {
        hasil[d.id_makanan] = (hasil[d.id_makanan] ?? 0) + d.jumlah;
      }
    }
    return hasil;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Grafik Penjualan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: Consumer2<Makanans, Penjualans>(
                builder: (context, makanans, penjualans, _) {
                  final porsiMap = _hitungPorsi(penjualans.datas);

                  final maxValue = porsiMap.values.isEmpty
                      ? 1
                      : porsiMap.values.reduce((a, b) => a > b ? a : b);

                  // ===============================
                  // 🔥 SORT MAKANAN BERDASARKAN PENJUALAN
                  // ===============================
                  final sortedMakanans = [...makanans.datas];
                  sortedMakanans.sort((a, b) {
                    final jumlahA = porsiMap[a.id] ?? 0;
                    final jumlahB = porsiMap[b.id] ?? 0;
                    return jumlahB.compareTo(jumlahA); // DESC
                  });

                  return ListView.builder(
                    itemCount: sortedMakanans.length,
                    itemBuilder: (context, index) {
                      final makanan = sortedMakanans[index];
                      final jumlah = porsiMap[makanan.id] ?? 0;
                      final factor = jumlah / maxValue;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            // LABEL
                            SizedBox(
                              width: 90,
                              child: Text(
                                makanan.nama,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // BAR
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: factor,
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 8),

                            // JUMLAH
                            Text(
                              jumlah.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
