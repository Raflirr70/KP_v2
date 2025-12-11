import 'package:flutter/material.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/screen/owner/daftar_stock.dart';
import 'package:kerprak/widget/list/list_makanan.dart';
import 'package:kerprak/widget/search/search_simple.dart';
import 'package:provider/provider.dart';

class DaftarMakanan extends StatefulWidget {
  const DaftarMakanan({super.key});

  @override
  State<DaftarMakanan> createState() => _DaftarMakananState();
}

class _DaftarMakananState extends State<DaftarMakanan> {
  final _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Makanans>(context, listen: false).getMakanan();
    });

    _searchController.addListener(() {
      setState(() {}); // Trigger rebuild untuk filter list
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Makanans>(
      builder: (context, value, child) {
        if (value.isLoading) return Center(child: CircularProgressIndicator());

        // Filter langsung tanpa provider
        List<Makanan> filtered = value.datas
            .where(
              (u) => u.nama.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              ),
            )
            .toList();

        return Scaffold(
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
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },

                      child: Row(
                        children: [
                          Icon(Icons.temple_buddhist_outlined),
                          SizedBox(width: 5),
                          Text(
                            "Ampera Saiyo",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DaftarStock()),
                      );
                    },
                    icon: Icon(Icons.add_card),
                  ),
                ],
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

          body: SafeArea(
            child: Center(
              child: Column(
                children: [
                  Consumer<Makanans>(
                    builder: (context, value, child) {
                      if (value.isLoading) {
                        return SizedBox(
                          height: 90,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      return Card(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: _summaryBox(
                                  "Total Makanan",
                                  value.datas.length.toString(),
                                  Colors.blue,
                                  Icons.trending_up,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 20),
                  SearchSimple(controller: _searchController),
                  SizedBox(height: 10, width: 250, child: Divider(height: 2)),
                  ListMakanan(value: filtered),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ========================== WIDGET SUMMARY BOX ==========================
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
