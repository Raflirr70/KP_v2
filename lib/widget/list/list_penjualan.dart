import 'package:flutter/material.dart';
import 'package:kerprak/model/penjualan.dart';
import 'package:kerprak/screen/karyawan/add_penjualan.dart';
import 'package:provider/provider.dart';

class ListPenjualan extends StatelessWidget {
  final id_cabang;
  const ListPenjualan({super.key, required this.id_cabang});

  String formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hour.toString().padLeft(2, '0');
    final minute = tod.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    if (id_cabang == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Consumer<Penjualans>(
      builder: (context, penjualan, child) {
        if (penjualan.datas.isEmpty) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPenjualanPage(idCabang: id_cabang),
                ),
              );
            },
            child: Card(
              elevation: 3,
              color: Colors.green[100],
              margin: EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsetsGeometry.symmetric(vertical: 16),
                child: Icon(Icons.add_circle),
              ),
            ),
          );
        }

        return Expanded(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddPenjualanPage(idCabang: id_cabang),
                    ),
                  );
                },
                child: Card(
                  elevation: 3,
                  color: Colors.green[100],
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsetsGeometry.symmetric(vertical: 16),
                    child: Icon(Icons.add_circle),
                  ),
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  itemCount: penjualan.datas.length,
                  itemBuilder: (context, index) {
                    final p = penjualan.datas[index];

                    return Card(
                      elevation: 3,
                      color: Colors.green[50],
                      margin: EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // =================== JAM + TOTAL HARGA ===================
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    formatTimeOfDay(p.jam),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Rp ${p.totalHarga}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 8),

                            // =================== DETAIL PENJUALAN ===================
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: p.detail.map((d) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          d.namaMakanan,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${d.jumlah}x",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "Rp ${d.totalHarga}",
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),

                            SizedBox(height: 6),

                            Divider(),

                            // =================== RINGKASAN ===================
                            Row(
                              children: [
                                Icon(
                                  Icons.shopping_bag,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "${p.detail.fold(0, (s, x) => s + x.jumlah)} Porsi",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.calendar_today,
                                  size: 13,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  formatTimeOfDay(p.jam),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[700],
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
          ),
        );
      },
    );
  }
}
