import 'package:flutter/material.dart';
import 'package:kerprak/model/distribusi.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/stock.dart';
import 'package:provider/provider.dart';

void showPilihMakananPopup(
  BuildContext context,
  Makanans makananValue,
  String idCabangDari,
  String idCabangTujuan,
) {
  TextEditingController searchController = TextEditingController();
  List<Makanan> filteredList = List.from(makananValue.datas);

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.orange[50],
            insetPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            title: Text(
              "Pilih Makanan",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: Column(
                children: [
                  // SEARCH BAR
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: "Cari makanan...",
                          hintStyle: TextStyle(fontSize: 14),
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
                    ),
                  ),

                  SizedBox(height: 8),

                  // LIST MAKANAN
                  Expanded(
                    child: ListView.separated(
                      itemCount: filteredList.length,
                      separatorBuilder: (context, i) =>
                          Divider(height: 1, color: Colors.black26),
                      itemBuilder: (context, i) {
                        final m = filteredList[i];

                        final stock =
                            Provider.of<Stocks>(
                              context,
                              listen: false,
                            ).datas.firstWhere(
                              (s) =>
                                  s.idCabang == idCabangDari &&
                                  s.idMakanan == m.id,
                              orElse: () => Stock(
                                id: "-",
                                idCabang: "-",
                                idMakanan: "-",
                                jumlahStock: 0,
                              ),
                            );

                        return ListTile(
                          dense: true,
                          title: Text(m.nama),
                          trailing: Text("${stock.jumlahStock}"),
                          hoverColor: Colors.orange[100],
                          onTap: () {
                            Navigator.pop(context, m); // Kirim object
                          },
                        );
                      },
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
      (s) => s.idCabang == idCabangDari && s.idMakanan == selectedMakanan.id,
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
              insetPadding: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.orange[50],
              title: Row(
                children: [
                  Text(makanan.nama, style: TextStyle(fontSize: 17)),
                  Spacer(),
                  Text(
                    "Stock: ${stock.jumlahStock}",
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 40,
                    child: TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Masukkan jumlah",
                        hintStyle: TextStyle(fontSize: 14),
                        errorText: errorText,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                        errorText = "Masukkan nilai yang valid";
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
      idCabangDari: idCabangDari,
      idCabangTujuan: idCabangTujuan,
      idMakanan: makanan.id,
      jumlah: jumlah!,
    );

    // KURANGI STOCK CABANG ASAL
    final stockAsal = stockProvider.datas.firstWhere(
      (s) => s.idCabang == idCabangDari && s.idMakanan == makanan.id,
      orElse: () => Stock(
        id: "-",
        idCabang: idCabangDari,
        idMakanan: makanan.id,
        jumlahStock: 0,
      ),
    );

    if (stockAsal.id != "-") {
      await stockProvider.saveStock(
        idMakanan: makanan.id,
        idCabang: idCabangDari,
        jumlahStock: stockAsal.jumlahStock - jumlah!,
      );
    } else {
      await stockProvider.saveStock(
        idMakanan: makanan.id,
        idCabang: idCabangDari,
        jumlahStock: 0,
      );
    }

    // TAMBAH STOCK CABANG TUJUAN
    final stockTujuan = stockProvider.datas.firstWhere(
      (s) => s.idCabang == idCabangTujuan && s.idMakanan == makanan.id,
      orElse: () => Stock(
        id: "-",
        idCabang: idCabangTujuan,
        idMakanan: makanan.id,
        jumlahStock: 0,
      ),
    );

    await stockProvider.saveStock(
      idMakanan: makanan.id,
      idCabang: idCabangTujuan,
      jumlahStock: stockTujuan.jumlahStock + jumlah!,
    );
    Provider.of<Stocks>(context, listen: false).getAllStocks();
  });
}
