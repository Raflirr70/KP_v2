import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kerprak/model/pengeluaran.dart';
import 'package:kerprak/widget/list/list_penjualan.dart';
import 'package:provider/provider.dart';
import 'package:kerprak/model/penjualan.dart';

class PenjualanPage extends StatefulWidget {
  final id_cabang;
  const PenjualanPage({super.key, required this.id_cabang});

  @override
  State<PenjualanPage> createState() => _PenjualanPageState();
}

class _PenjualanPageState extends State<PenjualanPage> {
  bool _showSummary = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Penjualans>(
        context,
        listen: false,
      ).getPenjualanByIdCabang(widget.id_cabang);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50], // Lebih lembut dari grey[100]
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16), // atur radius sesukamu
            ),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blueAccent,
              title: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.temple_buddhist_outlined),
                        SizedBox(width: 5),
                        Text(
                          "Cipanas",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Ujang Sopandi", style: TextStyle(fontSize: 10)),
                      Text(
                        "Karyawan",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 5),
                  InkWell(
                    onTap: () {},
                    child: Icon(Icons.account_circle_rounded, size: 30),
                  ),
                ],
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.lightBlueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
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
                    ? Card(
                        key: ValueKey("summary"),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Consumer<Penjualans>(
                            builder: (context, value, child) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: _summaryBox(
                                      "Total Pendapatan",
                                      value.Pendapatan().toString(),
                                      Colors.green,
                                      Icons.trending_up,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: _summaryBox(
                                      "Jumlah Terjual",
                                      value.datas.length.toString(),
                                      Colors.teal,
                                      Icons.shopping_cart,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
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
                    Icon(Icons.store, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      "Daftar Penjualan",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.store, color: Colors.green),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),

            ListPenjualan(id_cabang: widget.id_cabang),
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
