import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/distribusi.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/stock.dart';
import 'package:kerprak/widget/dll/card_cabang.dart';
import 'package:kerprak/widget/list/list_distribusi.dart';
import 'package:provider/provider.dart';

class DistribusiPage extends StatefulWidget {
  const DistribusiPage({super.key});

  @override
  State<DistribusiPage> createState() => _DistribusiPageState();
}

class _DistribusiPageState extends State<DistribusiPage> {
  final _searchController = TextEditingController();

  String? cabangDari;
  String? cabangTujuan;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Makanans>(context, listen: false).getMakanan();
      Provider.of<Cabangs>(context, listen: false).getCabang();
      Provider.of<Distribusis>(context, listen: false).getDistribusiHariIni();
      Provider.of<Stocks>(context, listen: false).getAllStocks();
    });

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String namaCabang(String? id) {
    if (id == null) return "-";
    final cab = Provider.of<Cabangs>(
      context,
      listen: false,
    ).datas.firstWhere((e) => e.id == id);
    return cab.nama;
  }

  String idCabang(String? id) {
    if (id == null) return "-";
    final cab = Provider.of<Cabangs>(
      context,
      listen: false,
    ).datas.firstWhere((e) => e.id == id);
    return cab.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Halaman Distribusi"), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            // decoration: BoxDecoration(
            //   border: Border.all(),
            //   borderRadius: BorderRadius.circular(15),
            // ),
            child: Column(
              children: [
                Consumer<Cabangs>(
                  builder: (context, value, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // CABANG ASAL
                        SizedBox(
                          width: 120,
                          height: 90,
                          child: ElevatedButton(
                            onPressed: () async {
                              final pilih = await showDialog(
                                context: context,
                                builder: (_) =>
                                    const PilihanCabangDialog(pilihDari: true),
                              );

                              if (pilih != null) {
                                setState(() => cabangDari = pilih);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                width: 5,
                                color: cabangDari == null
                                    ? Colors.red.shade400
                                    : Colors.green.shade400,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.local_shipping, size: 38),

                                Text(
                                  cabangDari == null
                                      ? "Pilih Asal"
                                      : namaCabang(cabangDari),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Icon(
                            Icons.keyboard_double_arrow_right,
                            size: 30,
                          ),
                        ),

                        // CABANG TUJUAN
                        SizedBox(
                          width: 120,
                          height: 90,
                          child: ElevatedButton(
                            onPressed: () async {
                              final pilih = await showDialog(
                                context: context,
                                builder: (_) =>
                                    const PilihanCabangDialog(pilihDari: false),
                              );

                              if (pilih != null) {
                                setState(() => cabangTujuan = pilih);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                width: 5,
                                color: cabangTujuan == null
                                    ? Colors.red.shade400
                                    : Colors.green.shade400,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.storefront_rounded, size: 38),

                                Text(
                                  cabangTujuan == null
                                      ? "Pilih Tujuan"
                                      : namaCabang(cabangTujuan),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                Container(
                  width: 250,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Divider(height: 3),
                ),

                // LIST DISTRIBUSI
                Expanded(
                  child: ListDistribusi(
                    id_cabang_dari: idCabang(cabangDari),
                    id_cabang_tujuan: idCabang(cabangTujuan),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
