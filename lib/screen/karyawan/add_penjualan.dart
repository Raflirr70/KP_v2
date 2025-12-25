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
  bool _isSubmitting = false;

  List<Makanan> _allMakanan = [];

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
    if (x == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(16), // atur radius sesukamu
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.blueAccent,
            title: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 16),
                const Text(
                  "Tambah Penjualan",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),

      // ================== BOTTOM BUTTON ==================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: (_isSubmitting || jumlahBeli.isEmpty)
              ? null
              : () {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        insetPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Daftar Makanan:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),

                              // ===== LIST MAKANAN =====
                              Flexible(
                                child: ListView(
                                  shrinkWrap: true,
                                  children: jumlahBeli.entries.map((entry) {
                                    final makanan = _allMakanan.firstWhere(
                                      (m) => m.id == entry.key,
                                    );

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "${makanan.nama} x${entry.value}",
                                            ),
                                          ),
                                          Text(
                                            "Rp ${makanan.harga * entry.value}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),

                              const Divider(),

                              // ===== TOTAL =====
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Total",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Rp $totalHarga",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                            },
                            child: const Text('Batal'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                              _submitPenjualan(context);
                            },
                            child: const Text('Ya, Jual'),
                          ),
                        ],
                      );
                    },
                  );
                },

          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            backgroundColor: Colors.green,
          ),
          child: _isSubmitting
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(
                  "JUAL  •  Rp $totalHarga",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),

      // ================== BODY ==================
      body: StreamBuilder<List<Makanan>>(
        stream: context.read<Makanans>().streamMakanan(),
        builder: (context, makananSnap) {
          if (!makananSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final listMakanan = makananSnap.data!;
          _allMakanan = listMakanan; // ✅ simpan ke state

          return StreamBuilder<List<Stock>>(
            stream: context.read<Stocks>().streamStockByIdCabang(
              widget.idCabang,
            ),
            builder: (context, stockSnap) {
              if (!stockSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final listStock = stockSnap.data!;

              List<Makanan> filtered = listMakanan
                  .where(
                    (m) => m.nama.toLowerCase().contains(
                      _searchController.text.toLowerCase(),
                    ),
                  )
                  .toList();

              return Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SearchSimple(controller: _searchController),
                  ),
                  const Divider(),

                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
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

                        stokSisa.putIfAbsent(
                          item.id,
                          () => stockItem.jumlahStock,
                        );

                        final qty = jumlahBeli[item.id] ?? 0;
                        bool tersedia = stokSisa[item.id]! > 0;

                        return Card(
                          color: tersedia ? Colors.white : Colors.blueGrey[100],
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.nama,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("Rp ${item.harga}"),
                                      Text(
                                        "Stock: ${stokSisa[item.id]}",
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // ===== BUTTON +/- =====
                                Row(
                                  children: [
                                    if (qty > 0)
                                      InkWell(
                                        onTap: () {
                                          jumlahBeli[item.id] = qty - 1;
                                          stokSisa[item.id] =
                                              stokSisa[item.id]! + 1;
                                          _hitungTotal(listMakanan);
                                        },
                                        child: _btn(
                                          Icons.remove,
                                          Colors.red[100],
                                        ),
                                      ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "$qty",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    InkWell(
                                      onTap: stokSisa[item.id]! > 0
                                          ? () {
                                              jumlahBeli[item.id] = qty + 1;
                                              stokSisa[item.id] =
                                                  stokSisa[item.id]! - 1;
                                              _hitungTotal(listMakanan);
                                            }
                                          : null,
                                      child: _btn(
                                        Icons.add,
                                        tersedia
                                            ? Colors.green[100]
                                            : Colors.grey[300],
                                      ),
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
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 18),
    );
  }

  Future<void> _submitPenjualan(BuildContext context) async {
    setState(() => _isSubmitting = true);
    final makananList = await context.read<Makanans>().getMakanan();
    final penjualan = context.read<Penjualans>();
    final stockProvider = context.read<Stocks>();

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
