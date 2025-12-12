import 'package:flutter/material.dart';
import 'package:kerprak/widget/navbar/appbar_karyawan.dart';
import 'package:kerprak/widget/navbar/navbar_karyawan.dart';
import 'package:kerprak/widget/popup/show_tambah_pengeluaran_karyawan.dart';
import 'package:provider/provider.dart';
import 'package:kerprak/model/pengeluaran.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengeluaranPage extends StatefulWidget {
  final id_cabang;
  const PengeluaranPage({super.key, required this.id_cabang});

  @override
  State<PengeluaranPage> createState() => _PengeluaranPageState();
}

class _PengeluaranPageState extends State<PengeluaranPage> {
  bool _showSummary = true;
  String? x;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initLaporan();
  }

  void _initLaporan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      x = prefs.getString("id_laporan");
    });
  }

  @override
  Widget build(BuildContext context) {
    final penjualanStream = context
        .read<Pengeluarans>()
        .streamPenjualanByIdLaporan(x!);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50], // Lebih lembut dari grey[100]
        bottomNavigationBar: NavbarKaryawan(id_cab: "widget.id_cabang", x: 1),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppbarKaryawan(id_cabang: widget.id_cabang),
        ),

        body: Column(
          children: [
            // =================== SUMMARY CARD ===================
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0, -0.1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _showSummary
                    ? Consumer<Pengeluarans>(
                        builder: (context, value, child) {
                          return Card(
                            key: ValueKey("summary"),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _summaryBox(
                                      "Total Hari Ini",
                                      value.totalPengeluaranLocal.toString(),
                                      Colors.redAccent,
                                      Icons.money_off,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: _summaryBox(
                                      "Transaksi",
                                      value.datas.length.toString(),
                                      Colors.deepOrange,
                                      Icons.list,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : SizedBox.shrink(key: ValueKey("empty")),
              ),
            ),

            // ==================== LABEL ====================
            InkWell(
              onTap: () => setState(() => _showSummary = !_showSummary),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wallet, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text(
                      "Daftar Pengeluaran",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.wallet, color: Colors.redAccent),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),

            // ==================== LIST PENGELUARAN ====================
            Expanded(
              child: StreamBuilder(
                stream: penjualanStream,
                builder: (context, asyncSnapshot) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 70,
                        width: double.infinity,
                        child: InkWell(
                          onTap: () {
                            showTambahPengeluaranKaryawanPopup(
                              context,
                              widget.id_cabang,
                              x!,
                            );
                          },
                          child: Card(
                            elevation: 3,
                            color: Colors.red[100],
                            margin: EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                vertical: 16,
                              ),
                              child: Icon(Icons.add_circle),
                            ),
                          ),
                        ),
                      ),
                      if (!asyncSnapshot.hasData)
                        Expanded(
                          child: Opacity(
                            opacity: 0.5,
                            child: Image.asset("../../lib/asset/notFound.png"),
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            itemCount: asyncSnapshot.data!.length,
                            itemBuilder: (context, index) {
                              final p = asyncSnapshot.data![index];
                              return InkWell(
                                onTap: () {},
                                child: Card(
                                  elevation: 3,
                                  color: Colors.red[50],
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Judul + Harga
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                p.namaPengeluaran,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Rp ${p.jumlahUnit}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 6),

                                        // Keterangan lebih kecil
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              size: 14,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              p.totalHarga.toString(),
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
                                ),
                              );
                            },
                          ),
                        ),
                    ],
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
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
