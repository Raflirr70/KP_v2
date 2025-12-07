import 'package:flutter/material.dart';
import 'package:kerprak/model/distribusi.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/stock.dart';
import 'package:provider/provider.dart';

void showPilihMakananPopup(
  BuildContext context,
  Makanans makananValue,
  String id_cabang_dari,
  String id_cabang_tujuan,
) {
  TextEditingController searchController = TextEditingController();
  List<Makanan> filteredList = List.from(makananValue.datas);

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Pilih Makanan"),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: Column(
                children: [
                  // =======================
                  // SEARCH BAR
                  // =======================
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Cari makanan...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        filteredList = makananValue.datas
                            .where(
                              (m) => m.nama.toLowerCase().contains(
                                value.toLowerCase(),
                              ),
                            )
                            .toList();
                      });
                    },
                  ),

                  SizedBox(height: 12),

                  // =======================
                  // LIST MAKANAN
                  // =======================
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(10),
                        child: ListView.builder(
                          itemCount: filteredList.length,
                          itemBuilder: (context, i) {
                            final m = filteredList[i];

                            // Ambil stock untuk cabang dari dan makanan ini
                            final stock =
                                Provider.of<Stocks>(
                                  context,
                                  listen: false,
                                ).datas.firstWhere(
                                  (s) =>
                                      s.idCabang == id_cabang_dari &&
                                      s.idMakanan == m.id,
                                  orElse: () => Stock(
                                    id: "-",
                                    idCabang: "-",
                                    idMakanan: "-",
                                    jumlahStock: 0,
                                  ),
                                );

                            return InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey, // warna border
                                      width: 1, // tebal border
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(m.nama),
                                  trailing: Text(
                                    "${stock.jumlahStock}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context, m); // KIRIM OBJECT
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  ).then((selectedMakanan) async {
    if (selectedMakanan == null) return;

    final Makanan makanan = selectedMakanan;
    final stock = Provider.of<Stocks>(context, listen: false).datas.firstWhere(
      (s) => s.idCabang == id_cabang_dari && s.idMakanan == selectedMakanan.id,
      orElse: () =>
          Stock(id: "-", idCabang: "-", idMakanan: "-", jumlahStock: 0),
    );

    int? jumlah;
    await showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        String? errorText;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Text("${makanan.nama}"),
                  Spacer(),
                  Text("Stock: ${stock.jumlahStock}"),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Masukkan jumlah",
                      errorText: errorText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final input = int.tryParse(controller.text);
                    if (input == null ||
                        input <= 0 ||
                        input > stock.jumlahStock) {
                      setState(() {
                        errorText = "Masukkan Nilai";
                      });
                    } else {
                      jumlah = input;
                      Navigator.pop(context);
                    }
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );

    if (jumlah == null) return;

    // SIMPAN DISTRIBUSI
    final distribusiProvider = Provider.of<Distribusis>(context, listen: false);
    final stockProvider = Provider.of<Stocks>(context, listen: false);

    await distribusiProvider.addDistribusi(
      idCabangDari: id_cabang_dari!,
      idCabangTujuan: id_cabang_tujuan!,
      idMakanan: makanan.id,
      jumlah: jumlah!,
    );

    // KURANGI STOCK CABANG ASAL
    final stockAsal = stockProvider.datas.firstWhere(
      (s) => s.idCabang == id_cabang_dari && s.idMakanan == makanan.id,
      orElse: () => Stock(
        id: "-",
        idCabang: id_cabang_dari!,
        idMakanan: makanan.id,
        jumlahStock: 0,
      ),
    );

    if (stockAsal.id != "-") {
      await stockProvider.saveStock(
        idMakanan: makanan.id,
        idCabang: id_cabang_dari!,
        jumlahStock: stockAsal.jumlahStock - jumlah!,
      );
    } else {
      await stockProvider.saveStock(
        idMakanan: makanan.id,
        idCabang: id_cabang_dari!,
        jumlahStock: 0,
      );
    }

    // TAMBAH STOCK CABANG TUJUAN
    final stockTujuan = stockProvider.datas.firstWhere(
      (s) => s.idCabang == id_cabang_tujuan && s.idMakanan == makanan.id,
      orElse: () => Stock(
        id: "-",
        idCabang: id_cabang_tujuan!,
        idMakanan: makanan.id,
        jumlahStock: 0,
      ),
    );

    await stockProvider.saveStock(
      idMakanan: makanan.id,
      idCabang: id_cabang_tujuan!,
      jumlahStock: stockTujuan.jumlahStock + jumlah!,
    );
  });
}
