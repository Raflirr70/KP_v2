import 'package:flutter/material.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/search.dart';
import 'package:kerprak/model/stock.dart';
import 'package:provider/provider.dart';

class ListStock extends StatefulWidget {
  Makanans value;
  ListStock({super.key, required this.value});

  @override
  State<ListStock> createState() => _ListStockState();
}

class _ListStockState extends State<ListStock> with TickerProviderStateMixin {
  int? expandedIndex; // item yang sedang terbuka

  void onTapItem(int? newIndex) {
    setState(() {
      expandedIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, sp, child) {
        return ListView.builder(
          itemCount: sp.filtered.length,
          itemBuilder: (context, index) {
            bool isExpanded = expandedIndex == index;

            return AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),

                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    onTapItem(isExpanded ? null : index);
                  },

                  child: Consumer<Stocks>(
                    builder: (context, s, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                sp.filtered[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Spacer(),
                              Text("${s.getTotalCabang(index)}"),
                            ],
                          ),

                          /// Ketika expanded → tampilkan detail stok
                          if (isExpanded) ...[
                            SizedBox(height: 20),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Stock",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),

                                Text(
                                  "Cipanas        : ${s.getJumlah(1, index)}",
                                ),
                                Text(
                                  "Balakang      : ${s.getJumlah(2, index)}",
                                ),
                                Text(
                                  "GSP             : ${s.getJumlah(3, index)}",
                                ),
                                Text(
                                  "Cimacan       : ${s.getJumlah(4, index)}",
                                ),
                                Text(
                                  "Gudang        : ${s.getJumlah(0, index)}",
                                ),

                                SizedBox(height: 15),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      height: 45,
                                      width: 150,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text("Stock Gudang"),
                                      ),
                                    ),

                                    SizedBox(
                                      height: 45,
                                      width: 150,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        child: Text(
                                          "Stock Cabang",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
