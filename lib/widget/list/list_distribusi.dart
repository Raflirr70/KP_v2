import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/distribusi.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/stock.dart';
import 'package:kerprak/widget/popup/show_tambah_distribusi.dart';
import 'package:provider/provider.dart';

class ListDistribusi extends StatefulWidget {
  String id_cabang_dari, id_cabang_tujuan;
  ListDistribusi({
    super.key,
    required this.id_cabang_dari,
    required this.id_cabang_tujuan,
  });

  @override
  State<ListDistribusi> createState() => _ListDistribusiState();
}

class _ListDistribusiState extends State<ListDistribusi> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<Distribusis, Makanans, Cabangs>(
      builder: (context, distribusiValue, makananValue, cabangValue, child) {
        final datas = distribusiValue.datas;

        return ListView.builder(
          itemCount: datas.length + 1,
          padding: EdgeInsets.symmetric(horizontal: 10),
          itemBuilder: (context, index) {
            // ====== TOMBOL ADD DI AKHIR ======
            if (index == datas.length) {
              return Container(
                height: 55,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Card(
                  elevation: 2,
                  child: InkWell(
                    onTap: () {
                      if (widget.id_cabang_dari == "-" ||
                          widget.id_cabang_tujuan == "-") {
                        // Tampilkan peringatan
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Pilih cabang terlebih dahulu!"),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return; // hentikan proses
                      }

                      // Jika cabang sudah dipilih, tampilkan popup makanan
                      showPilihMakananPopup(
                        context,
                        makananValue,
                        widget.id_cabang_dari,
                        widget.id_cabang_tujuan,
                      );
                    },
                    child: Center(child: Icon(Icons.add, size: 32)),
                  ),
                ),
              );
            }

            final item = datas[index];

            final makanan = makananValue.datas.firstWhere(
              (e) => e.id == item.id_makanan,
              orElse: () => Makanan(id: "-", nama: "Tidak ada", harga: 0),
            );

            final cabangDari = cabangValue.datas.firstWhere(
              (e) => e.id == item.id_cabang_dari,
              orElse: () => Cabang(id: "-", nama: "Tidak ada"),
            );

            final cabangTujuan = cabangValue.datas.firstWhere(
              (e) => e.id == item.id_cabang_tujuan,
              orElse: () => Cabang(id: "-", nama: "Tidak ada"),
            );

            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    // BARIS 1: Nama makanan + jumlah
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          makanan.nama,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${cabangDari.nama} -> ${cabangTujuan.nama}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),

                    Spacer(),

                    // BARIS 2: Cabang asal -> Cabang tujuan
                    Container(
                      width: 70,
                      padding: EdgeInsetsGeometry.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          item.jumlah.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
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
    );
  }
}
