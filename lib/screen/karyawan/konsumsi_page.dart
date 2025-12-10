import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/konsumsi.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/user.dart';
import 'package:kerprak/screen/karyawan/add_konsumsi.dart';
import 'package:kerprak/widget/navbar/appbar_karyawan.dart';
import 'package:kerprak/widget/navbar/navbar_karyawan.dart';
import 'package:provider/provider.dart';

class KonsumsiPage extends StatefulWidget {
  final id_cabang;
  const KonsumsiPage({super.key, required this.id_cabang});

  @override
  State<KonsumsiPage> createState() => _KonsumsiPageState();
}

class _KonsumsiPageState extends State<KonsumsiPage> {
  bool _showSummary = true;
  String formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hourOfPeriod.toString().padLeft(2, '0');
    final minute = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? "AM" : "PM";

    return "$hour:$minute $period";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50], // Lebih lembut dari grey[100]
        bottomNavigationBar: NavbarKaryawan(id_cab: widget.id_cabang, x: 2),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppbarKaryawan(id_cabang: widget.id_cabang),
        ),

        body: Column(
          children: [
            SizedBox(height: 10),

            // ==================== LIST PENJUALAN ====================
            Expanded(
              child: StreamBuilder<List<Konsumsi>>(
                stream: Provider.of<Konsumsis>(
                  context,
                  listen: false,
                ).streamKonsumsi(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddKonsumsi(idCabang: widget.id_cabang),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 3,
                        color: Colors.deepOrange[100],
                        margin: EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Icon(Icons.add_circle),
                        ),
                      ),
                    );
                  }
                  final datas = snapshot.data!;

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    itemCount: datas.length + 1,
                    itemBuilder: (context, index) {
                      if (datas.length == index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddKonsumsi(idCabang: widget.id_cabang),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 3,
                            color: Colors.deepOrange[100],
                            margin: EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Icon(Icons.add_circle),
                            ),
                          ),
                        );
                      }
                      final p = datas[index];
                      return Consumer<Users>(
                        builder: (context, value, child) {
                          return Card(
                            elevation: 3,
                            color: Colors.deepOrange[50],
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
                                  // Nama menu + total harga
                                  Consumer<Users>(
                                    builder: (context, vva, child) {
                                      String u = vva.datas
                                          .firstWhere(
                                            (u) => u.id == p.idKaryawan,
                                          )
                                          .nama;
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              u,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: p.detailKonsumsi.map((d) {
                                              return Consumer<Makanans>(
                                                builder: (context, value, child) {
                                                  final ms = value.datas
                                                      .firstWhere(
                                                        (m) =>
                                                            m.id == d.idMakanan,
                                                      );
                                                  return Row(
                                                    children: [
                                                      Text(
                                                        ms.nama,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.deepOrange,
                                                        ),
                                                      ),
                                                      Text(
                                                        "  x ${d.jumlah.toString()}",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.deepOrange,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      );
                                    },
                                  ),

                                  SizedBox(height: 6),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =================== SUMMARY BOX ===================
  Widget _summaryBox(String label, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
