import 'package:flutter/material.dart';
import 'package:kerprak/model/penjualan.dart';
import 'package:provider/provider.dart';

class ListPenjualan extends StatelessWidget {
  const ListPenjualan({super.key});
  String formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hourOfPeriod.toString().padLeft(2, '0');
    final minute = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? "AM" : "PM";

    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<Penjualans>(
        builder: (context, value, child) {
          if (value.datas.isEmpty) {
            return Center(
              child: Text(
                "Belum ada data penjualan",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemCount: 4,
            itemBuilder: (context, index) {
              if (index != 3) {
                final p = value.datas[index];
                return Card(
                  elevation: 3,
                  color: Colors.green[50],
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama menu + total jual
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                formatTimeOfDay(p.jam!),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              "Rp ${p.total_harga}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 6),

                        // Jumlah terjual + tanggal
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.shopping_bag,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  " Porsi",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 13,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  p.total_harga.toString(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
              return InkWell(
                onTap: () {},
                child: Card(
                  elevation: 3,
                  color: Colors.green[100],
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(vertical: 16),
                    child: Icon(Icons.add_circle),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
