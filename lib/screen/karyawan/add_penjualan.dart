import 'package:flutter/material.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/stock.dart';
import 'package:kerprak/model/penjualan.dart';
import 'package:kerprak/widget/search/search_simple.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Makanans>(context, listen: false).getMakanan();
      Provider.of<Stocks>(
        context,
        listen: false,
      ).getStocksByIdCabang(widget.idCabang);
    });

    // Listener search
    _searchController.addListener(() {
      setState(() {}); // untuk filter list
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _hitungTotal(Makanans makanan) {
    int total = 0;

    jumlahBeli.forEach((idMakanan, qty) {
      final m = makanan.datas.firstWhere((e) => e.id == idMakanan);
      total += m.harga * qty;
    });

    setState(() => totalHarga = total);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Penjualan"),
        backgroundColor: Colors.green,
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: () => _submitPenjualan(context),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14),
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            "JUAL  •  Rp $totalHarga",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),

      body: Consumer3<Makanans, Stocks, Penjualans>(
        builder: (context, makanan, stock, penjualanProvider, child) {
          if (makanan.isLoading || stock.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          // FILTER LIST SESUAI SEARCH
          List<Makanan> filtered = makanan.datas
              .where(
                (m) => m.nama.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ),
              )
              .toList();

          return Column(
            children: [
              SizedBox(height: 10),

              // 🔍 SEARCH INPUT
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: SearchSimple(controller: _searchController),
              ),

              SizedBox(height: 10, width: 250, child: Divider(height: 2)),

              // LIST VIEW
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];

                    final stockItem = stock.datas.firstWhere(
                      (x) =>
                          x.idCabang == widget.idCabang &&
                          x.idMakanan == item.id,
                      orElse: () => Stock(
                        id: "",
                        idCabang: widget.idCabang,
                        idMakanan: item.id,
                        jumlahStock: 0,
                      ),
                    );

                    if (!stokSisa.containsKey(item.id)) {
                      stokSisa[item.id] = stockItem.jumlahStock;
                    }

                    final int qty = jumlahBeli[item.id] ?? 0;

                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.nama,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Rp ${item.harga}",
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "Stock: ${stokSisa[item.id]}",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // TOMBOL +/-
                            Row(
                              children: [
                                InkWell(
                                  onTap: qty > 0
                                      ? () {
                                          jumlahBeli[item.id] = qty - 1;
                                          stokSisa[item.id] =
                                              stokSisa[item.id]! + 1;

                                          _hitungTotal(makanan);
                                          setState(() {});
                                        }
                                      : null,
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.red[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.remove, size: 18),
                                  ),
                                ),

                                SizedBox(width: 10),

                                Text(
                                  "$qty",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(width: 10),

                                InkWell(
                                  onTap: stokSisa[item.id]! > 0
                                      ? () {
                                          jumlahBeli[item.id] = qty + 1;
                                          stokSisa[item.id] =
                                              stokSisa[item.id]! - 1;

                                          _hitungTotal(makanan);
                                          setState(() {});
                                        }
                                      : null,
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.add, size: 18),
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
      ),
    );
  }

  Future<void> _submitPenjualan(BuildContext context) async {
    final makanan = Provider.of<Makanans>(context, listen: false);
    final penjualan = Provider.of<Penjualans>(context, listen: false);
    final stockProvider = Provider.of<Stocks>(context, listen: false);

    if (jumlahBeli.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Tidak ada makanan yang dipilih")));
      return;
    }

    // Buat penjualan
    Penjualan p = Penjualan(
      id: "",
      detail: [],
      totalHarga: totalHarga,
      jam: TimeOfDay.now(),
    );

    // Tambahkan detail transaksi
    jumlahBeli.forEach((idMakanan, qty) {
      final m = makanan.datas.firstWhere((e) => e.id == idMakanan);

      p.detail.add(
        DetailPenjualan(
          id: "",
          namaMakanan: m.nama,
          jumlah: qty,
          totalHarga: m.harga * qty,
        ),
      );
    });

    // 🚀 SIMPAN PENJUALAN
    await penjualan.tambahPenjualan(p);

    // 🚀 UPDATE STOCK FIREBASE
    for (var entry in jumlahBeli.entries) {
      final idMakanan = entry.key;
      final sisaBaru = stokSisa[idMakanan]!;

      await stockProvider.saveStock(
        idMakanan: idMakanan,
        idCabang: widget.idCabang,
        jumlahStock: sisaBaru,
      );
    }

    Navigator.pop(context);
  }
}
