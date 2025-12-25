import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/stock.dart';

void showUpdateStock(
  BuildContext context, {
  required Stocks stocks,
  required List<Cabang> cabang,
  required String idMakanan,
}) async {
  // Ambil ID cabang
  String idGudang = cabang.firstWhere((c) => c.nama == "Gudang").id;
  String idCipanas = cabang.firstWhere((c) => c.nama == "Cipanas").id;
  String idCimacan = cabang.firstWhere((c) => c.nama == "Cimacan").id;
  String idBalakang = cabang.firstWhere((c) => c.nama == "Balakang").id;
  String idGsp = cabang.firstWhere((c) => c.nama == "Gsp").id;

  int ambilStock(String idCabang) {
    return stocks.datas
        .firstWhere(
          (s) => s.idCabang == idCabang && s.idMakanan == idMakanan,
          orElse: () => Stock(
            id: "",
            idCabang: idCabang,
            idMakanan: idMakanan,
            jumlahStock: 0,
          ),
        )
        .jumlahStock;
  }

  final stokGudangAwal = ambilStock(idGudang);
  final stokCipanasAwal = ambilStock(idCipanas);
  final stokCimacanAwal = ambilStock(idCimacan);
  final stokBalakangAwal = ambilStock(idBalakang);
  final stokGspAwal = ambilStock(idGsp);

  final stockTotalAwal =
      stokGudangAwal +
      stokCipanasAwal +
      stokCimacanAwal +
      stokBalakangAwal +
      stokGspAwal;

  final gudangC = TextEditingController(text: stokGudangAwal.toString());
  final cipanasC = TextEditingController(text: stokCipanasAwal.toString());
  final cimacanC = TextEditingController(text: stokCimacanAwal.toString());
  final balakangC = TextEditingController(text: stokBalakangAwal.toString());
  final gspC = TextEditingController(text: stokGspAwal.toString());
  final selisih = TextEditingController(text: "0");

  void hitungOtomatis() {
    int gudang = int.tryParse(gudangC.text) ?? stokGudangAwal;
    int cipanas = int.tryParse(cipanasC.text) ?? stokCipanasAwal;
    int cimacan = int.tryParse(cimacanC.text) ?? stokCimacanAwal;
    int balakang = int.tryParse(balakangC.text) ?? stokBalakangAwal;
    int gsp = int.tryParse(gspC.text) ?? stokGspAwal;

    final totalBaru = gudang + cipanas + cimacan + balakang + gsp;
    final delta = totalBaru - stockTotalAwal;

    selisih.text = delta.toString();
  }

  gudangC.addListener(hitungOtomatis);
  cipanasC.addListener(hitungOtomatis);
  cimacanC.addListener(hitungOtomatis);
  balakangC.addListener(hitungOtomatis);
  gspC.addListener(hitungOtomatis);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.orange[50],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Edit Stock",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),

                // GUDANG + SELISIH
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: buildFieldOrange("Gudang", gudangC),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: buildFieldOrange("Δ", selisih, readOnly: true),
                    ),
                  ],
                ),

                // 2 kolom
                Row(
                  children: [
                    Expanded(child: buildFieldOrange("Cipanas", cipanasC)),
                    SizedBox(width: 10),
                    Expanded(child: buildFieldOrange("Cimacan", cimacanC)),
                  ],
                ),

                Row(
                  children: [
                    Expanded(child: buildFieldOrange("Balakang", balakangC)),
                    SizedBox(width: 10),
                    Expanded(child: buildFieldOrange("GSP", gspC)),
                  ],
                ),

                SizedBox(height: 20),

                // SIMPAN BUTTON
                ElevatedButton.icon(
                  onPressed: () async {
                    if (selisih.text != "0") {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          insetPadding: EdgeInsets.all(16),
                          title: Text("Simpan Perubahan"),
                          content: Text(
                            (int.tryParse(selisih.text) ?? 0) > 0
                                ? "total penambahan stock ${selisih.text}"
                                : "total pengurangan stock ${selisih.text.replaceFirst('-', '')}",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text("Batal"),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text("Yakin"),
                            ),
                          ],
                        ),
                      );

                      if (confirm != true) {
                        return; // Batalkan penyimpanan jika tidak yakin
                      }
                    }
                    final Map<String, int> updatedStocks = {
                      idGudang: int.tryParse(gudangC.text) ?? 0,
                      idCipanas: int.tryParse(cipanasC.text) ?? 0,
                      idCimacan: int.tryParse(cimacanC.text) ?? 0,
                      idBalakang: int.tryParse(balakangC.text) ?? 0,
                      idGsp: int.tryParse(gspC.text) ?? 0,
                    };

                    for (var entry in updatedStocks.entries) {
                      await stocks.saveStock(
                        idMakanan: idMakanan,
                        idCabang: entry.key,
                        jumlahStock: entry.value,
                      );
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Berhasil tersimpan"),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.save),
                  label: Text("Simpan", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    iconColor: Colors.white,
                    backgroundColor: Colors.blue[400],
                    minimumSize: Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                SizedBox(height: 25),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget buildFieldOrange(
  String title,
  TextEditingController c, {
  bool readOnly = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: c,
      readOnly: readOnly,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: readOnly ? Colors.grey.shade200 : Colors.white,
        labelText: title,
        labelStyle: TextStyle(fontSize: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
