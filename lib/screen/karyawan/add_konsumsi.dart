import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kerprak/model/konsumsi.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/stock.dart';
import 'package:kerprak/model/user.dart';
import 'package:kerprak/model/jadwal.dart';
import 'package:kerprak/widget/navbar/appbar_karyawan.dart';
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppbarKaryawan(id_cabang: widget.idCabang),
      ),

      backgroundColor: Colors.deepOrange[100],
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 20, left: 16, right: 16),
        child: ElevatedButton(
          onPressed: () => _submitPenjualan(context),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14),
            backgroundColor: Colors.deepOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(20),
            ),
          ),
          child: Text(
            "Konsumsi  •  Rp $totalHarga",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new),
              ),
              Text(
                "Tambah Konsumsi",
                style: GoogleFonts.caveat(fontSize: 35, color: Colors.black87),
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 20, left: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: StreamBuilder<List<Makanan>>(
                stream: context.read<Makanans>().streamMakanan(),
                builder: (context, makananSnap) {
                  if (!makananSnap.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final listMakanan = makananSnap.data!;

                  return StreamBuilder<List<Stock>>(
                    stream: context.read<Stocks>().streamStockByIdCabang(
                      widget.idCabang,
                    ),
                    builder: (context, stockSnap) {
                      if (!stockSnap.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
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
                                          padding: EdgeInsets.symmetric(
                                            vertical: 16,
                                            horizontal: 16,
                                          ),
                                          height: 300,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Pilih Karyawan",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Divider(),
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount:
                                                      karyawanList.length,
                                                  itemBuilder: (context, index) {
                                                    final k =
                                                        karyawanList[index];
                                                    return ListTile(
                                                      title: Text(k.nama),
                                                      trailing:
                                                          selectedKaryawan ==
                                                              k.id
                                                          ? Icon(
                                                              Icons.check,
                                                              color: Colors
                                                                  .orange[200],
                                                            )
                                                          : null,
                                                      onTap: () {
                                                        setState(() {
                                                          selectedKaryawan =
                                                              k.id;
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
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange[50],
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          selectedKaryawan != null
                                              ? karyawanList
                                                    .firstWhere(
                                                      (k) =>
                                                          k.id ==
                                                          selectedKaryawan!,
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
                                SizedBox(
                                  width: double.infinity,
                                  child: SearchSimple(
                                    controller: _searchController,
                                  ),
                                ),
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
                                  color: stokSisa[item.id]! == 0
                                      ? Colors.blueGrey[100]
                                      : Colors.white,
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
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            if (qty > 0)
                                              InkWell(
                                                onTap: qty > 0
                                                    ? () {
                                                        jumlahBeli[item.id] =
                                                            qty - 1;
                                                        stokSisa[item.id] =
                                                            stokSisa[item.id]! +
                                                            1;
                                                        _hitungTotal(
                                                          listMakanan,
                                                        );
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
                                                      jumlahBeli[item.id] =
                                                          qty + 1;
                                                      stokSisa[item.id] =
                                                          stokSisa[item.id]! -
                                                          1;
                                                      _hitungTotal(listMakanan);
                                                    }
                                                  : null,
                                              child: _btn(
                                                Icons.add,
                                                stokSisa[item.id]! > 0
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
            ),
          ),
        ],
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
      idLaporan: x!,
      idKaryawan: selectedKaryawan!,
      jam: '',
      detailKonsumsi: [],
      id: '',
    );

    jumlahBeli.forEach((idMakanan, qty) {
      if (qty > 0) {
        k.detailKonsumsi.add(
          DetailKonsumsi(
            idMakanan: idMakanan,
            jumlah: qty, // 🔥 SIMPAN JUMLAH
          ),
        );
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
