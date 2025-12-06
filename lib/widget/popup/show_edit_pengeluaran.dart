import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:kerprak/model/pengeluaran.dart';

void showEditPengeluaranPopup(BuildContext context, Pengeluaran pengeluaran) {
  final namaC = TextEditingController(text: pengeluaran.namaPengeluaran);
  final jumlahC = TextEditingController(
    text: pengeluaran.jumlahUnit.toString(),
  );
  final hargaC = TextEditingController(text: pengeluaran.totalHarga.toString());
  String? selectedSatuan = pengeluaran.jenisSatuan;

  bool isEdited() {
    return namaC.text != pengeluaran.namaPengeluaran ||
        jumlahC.text != pengeluaran.jumlahUnit.toString() ||
        hargaC.text != pengeluaran.totalHarga.toString() ||
        selectedSatuan != pengeluaran.jenisSatuan;
  }

  final satuanList = ["unit", "liter", "kilo", "gram", "set", "box"];

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              "Edit Pengeluaran",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildField("Nama Pengeluaran", namaC),
                  SizedBox(height: 12),
                  buildField(
                    "Jumlah",
                    jumlahC,
                    keyboardType: TextInputType.number,
                    isNumber: true,
                  ),
                  SizedBox(height: 12),
                  buildField(
                    "Harga",
                    hargaC,
                    keyboardType: TextInputType.number,
                    isNumber: true,
                  ),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Jenis Satuan",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: satuanList.map((s) {
                      final selected = selectedSatuan == s;
                      return SizedBox(
                        width: 80,
                        height: 36,
                        child: ChoiceChip(
                          label: Center(
                            child: Text(
                              s,
                              style: TextStyle(
                                color: selected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          selected: selected,
                          selectedColor: Colors.blue,
                          backgroundColor: Colors.grey[300],
                          showCheckmark: false,
                          onSelected: (_) {
                            setState(() => selectedSatuan = s);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (isEdited()) {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text("Konfirmasi"),
                        content: Text("Hapus perubahan?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text("Tidak"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: Text("Ya"),
                          ),
                        ],
                      ),
                    );
                    if (confirm != true) return;
                  }
                  Navigator.pop(context);
                },
                child: Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () {
                  final nama = namaC.text.trim();
                  final jumlah = int.tryParse(jumlahC.text.trim()) ?? 0;
                  final harga = int.tryParse(hargaC.text.trim()) ?? 0;

                  if (nama.isEmpty ||
                      jumlah <= 0 ||
                      harga <= 0 ||
                      selectedSatuan == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Isi semua field dengan benar")),
                    );
                    return;
                  }

                  // Update data
                  pengeluaran.namaPengeluaran = nama;
                  pengeluaran.jumlahUnit = jumlah;
                  pengeluaran.totalHarga = harga;
                  pengeluaran.jenisSatuan = selectedSatuan!;

                  Provider.of<Pengeluarans>(
                    context,
                    listen: false,
                  ).updateData(pengeluaran);

                  Navigator.pop(context);
                },
                child: Text("Simpan"),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget buildField(
  String label,
  TextEditingController c, {
  TextInputType keyboardType = TextInputType.text,
  bool isNumber = false,
}) {
  return TextField(
    controller: c,
    keyboardType: keyboardType,
    inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    ),
  );
}
