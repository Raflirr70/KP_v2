import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kerprak/model/konsumsi.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/stock.dart';
import 'package:kerprak/model/user.dart';
import 'package:kerprak/model/jadwal.dart';
import 'package:kerprak/widget/search/search_simple.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddKonsumsi extends StatefulWidget {
  final String idCabang;
  const AddKonsumsi({super.key, required this.idCabang});

  @override
  State<AddKonsumsi> createState() => _AddKonsumsiState();
}

class _AddKonsumsiState extends State<AddKonsumsi> {
  final TextEditingController _searchController = TextEditingController();

  Map<String, int> jumlahBeli = {};
  Map<String, int> stokSisa = {};
  int totalHarga = 0;
  String? selectedKaryawan;
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
    // Ambil karyawan berdasarkan jadwal cabang
    final jadwalProvider = context.read<Jadwals>();
    final karyawanIds = jadwalProvider
        .getByCabang(widget.idCabang)
        .map((j) => j.id_user)
        .toList();

    final usersProvider = context.read<Users>();
    final karyawanList = usersProvider.datas
        .where((u) => karyawanIds.contains(u.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Konsumsi"),
        backgroundColor: Colors.green,
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

              // Filter makanan sesuai search
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tombol popup pilih karyawan
                        Text(
                          "Pilih Karyawan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 5),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              builder: (context) {
                                return Container(
                                  padding: EdgeInsets.all(16),
                                  height: 300,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Pilih Karyawan",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Divider(),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: karyawanList.length,
                                          itemBuilder: (context, index) {
                                            final k = karyawanList[index];
                                            return ListTile(
                                              title: Text(k.nama),
                                              trailing: selectedKaryawan == k.id
                                                  ? Icon(
                                                      Icons.check,
                                                      color: Colors.green,
                                                    )
                                                  : null,
                                              onTap: () {
                                                setState(() {
                                                  selectedKaryawan = k.id;
                                                });
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedKaryawan != null
                                      ? karyawanList
                                            .firstWhere(
                                              (k) => k.id == selectedKaryawan!,
                                            )
                                            .nama
                                      : "Pilih Karyawan",
                                  style: TextStyle(fontSize: 14),
                                ),
                                Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SearchSimple(controller: _searchController),
                      ],
                    ),
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
                                      Text(
                                        "Stock: ${stokSisa[item.id]}",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
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
    if (selectedKaryawan == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Silakan pilih karyawan")));
      return;
    }

    final makananList = await context.read<Makanans>().getMakanan();
    final konsumsi = context.read<Konsumsis>();
    final stockProvider = context.read<Stocks>();

    if (jumlahBeli.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Tidak ada makanan dipilih")));
      return;
    }

    Konsumsi k = Konsumsi(
      id: "",
      idLaporan: x!,
      idKaryawan: selectedKaryawan!,
      detailKonsumsi: [],
    );

    jumlahBeli.forEach((idMakanan, qty) {
      for (int i = 0; i < qty; i++) {
        k.detailKonsumsi.add(DetailKonsumsi(id: "", idMakanan: idMakanan));
      }
    });

    await konsumsi.tambahKonsumsi(k);

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
