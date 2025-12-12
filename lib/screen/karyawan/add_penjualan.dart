import 'package:flutter/material.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/stock.dart';
import 'package:kerprak/model/penjualan.dart';
import 'package:kerprak/widget/navbar/appbar_karyawan.dart';
import 'package:kerprak/widget/search/search_simple.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPenjualanPage extends StatefulWidget {
  final String idCabang;
  const AddPenjualanPage({super.key, required this.idCabang});

  @override
  State<AddPenjualanPage> createState() => _AddPenjualanPageState();
}

class _AddPenjualanPageState extends State<AddPenjualanPage> {
  final TextEditingController _searchController = TextEditingController();

  Map<String, int> jumlahBeli = {};
  Map<String, int> stokSisa = {};
  int totalHarga = 0;
  String? x;
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    _initLaporan();
  }

  void _initLaporan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      x = prefs.getString("id_laporan");
    });
  }

  void _hitungTotal(List<Makanan> makananList) {
    int total = 0;

    jumlahBeli.forEach((idMakanan, qty) {
      final m = makananList.firstWhere((e) => e.id == idMakanan);
      total += m.harga * qty;
    });

    setState(() => totalHarga = total);
  }

  @override
  Widget build(BuildContext context) {
    if (x == null) return CircularProgressIndicator();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppbarKaryawan(id_cabang: widget.idCabang),
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: () => _submitPenjualan(context),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14),
            backgroundColor: Colors.green,
          ),
          child: Text(
            "JUAL  •  Rp $totalHarga",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),

      body: StreamBuilder<List<Makanan>>(
        stream: context.read<Makanans>().streamMakanan(),
        builder: (context, makananSnap) {
          if (!makananSnap.hasData)
            return Center(child: CircularProgressIndicator());
          final listMakanan = makananSnap.data!;

          return StreamBuilder<List<Stock>>(
            stream: context.read<Stocks>().streamStockByIdCabang(
              widget.idCabang,
            ),
            builder: (context, stockSnap) {
              if (!stockSnap.hasData)
                return Center(child: CircularProgressIndicator());
              final listStock = stockSnap.data!;

              // Pencarian
              List<Makanan> filtered = listMakanan
                  .where(
                    (m) => m.nama.toLowerCase().contains(
                      _searchController.text.toLowerCase(),
                    ),
                  )
                  .toList();

              return Column(
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: SearchSimple(controller: _searchController),
                  ),
                  Divider(),

                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(12),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];

                        final stockItem = listStock.firstWhere(
                          (s) => s.idMakanan == item.id,
                          orElse: () => Stock(
                            id: "",
                            idCabang: widget.idCabang,
                            idMakanan: item.id,
                            jumlahStock: 0,
                          ),
                        );

                        // stok realtime
                        stokSisa.putIfAbsent(
                          item.id,
                          () => stockItem.jumlahStock,
                        );

                        final qty = jumlahBeli[item.id] ?? 0;

                        return Card(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.nama,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("Rp ${item.harga}"),
                                      Text(
                                        "Stock: ${stokSisa[item.id]}",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),

                                Row(
                                  children: [
                                    // MINUS
                                    InkWell(
                                      onTap: qty > 0
                                          ? () {
                                              jumlahBeli[item.id] = qty - 1;
                                              stokSisa[item.id] =
                                                  stokSisa[item.id]! + 1;
                                              _hitungTotal(listMakanan);
                                            }
                                          : null,
                                      child: _btn(
                                        Icons.remove,
                                        Colors.red[100],
                                      ),
                                    ),

                                    SizedBox(width: 10),
                                    Text(
                                      "$qty",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 10),

                                    // PLUS
                                    InkWell(
                                      onTap: stokSisa[item.id]! > 0
                                          ? () {
                                              jumlahBeli[item.id] = qty + 1;
                                              stokSisa[item.id] =
                                                  stokSisa[item.id]! - 1;
                                              _hitungTotal(listMakanan);
                                            }
                                          : null,
                                      child: _btn(Icons.add, Colors.green[100]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _btn(IconData icon, Color? color) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 18),
    );
  }

  Future<void> _submitPenjualan(BuildContext context) async {
    final makananList = await context.read<Makanans>().getMakanan();
    final penjualan = context.read<Penjualans>();
    final stockProvider = context.read<Stocks>();

    if (jumlahBeli.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Tidak ada makanan dipilih")));
      return;
    }

    Penjualan p = Penjualan(
      id: "",
      id_cabang: widget.idCabang,
      id_laporan: x!,
      totalHarga: totalHarga,
      jam: TimeOfDay.now(),
      detail: [],
    );

    jumlahBeli.forEach((idMakanan, qty) {
      final m = makananList.firstWhere((e) => e.id == idMakanan);
      p.detail.add(
        DetailPenjualan(
          id: "",
          id_makanan: m.id,
          jumlah: qty,
          totalHarga: m.harga * qty,
        ),
      );
    });

    await penjualan.tambahPenjualan(p);

    // update stock
    for (var entry in stokSisa.entries) {
      await stockProvider.saveStock(
        idMakanan: entry.key,
        idCabang: widget.idCabang,
        jumlahStock: entry.value,
      );
    }

    Navigator.pop(context);
  }
}
