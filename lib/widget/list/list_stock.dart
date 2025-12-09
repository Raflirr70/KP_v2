import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/stock.dart';
import 'package:kerprak/widget/popup/show_update_stock.dart';
import 'package:provider/provider.dart';

class ListStock extends StatefulWidget {
  final List<Makanan> value;
  ListStock({super.key, required this.value});

  @override
  State<ListStock> createState() => _ListStockState();
}

class _ListStockState extends State<ListStock> with TickerProviderStateMixin {
  int? expandedIndex;

  void onTapItem(int? newIndex) async {
    setState(() {
      expandedIndex = newIndex;
    });

    if (newIndex != null) {
      final makanan = widget.value[newIndex];
      await Provider.of<Stocks>(
        context,
        listen: false,
      ).getStocksById(makanan.id);
    }
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<Stocks>(context, listen: false).getAllStocks();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final makananList = widget.value;
    return ListView.builder(
      itemCount: makananList.length,
      itemBuilder: (context, index) {
        final isExpanded = expandedIndex == index;
        final makanan = makananList[index];

        return AnimatedSize(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 2,
                  offset: Offset(1, 2),
                ),
              ],
            ),
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => onTapItem(isExpanded ? null : index),
              child: Consumer<Cabangs>(
                builder: (context, cabangProvider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            makanan.nama,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          Consumer<Stocks>(
                            builder: (context, stock, child) {
                              return FutureBuilder<int>(
                                future: stock.getTotalStockByMakanan(
                                  makanan.id,
                                ),
                                builder: (context, snapshot) {
                                  return Text(snapshot.data?.toString() ?? "0");
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      if (isExpanded) ...[
                        Consumer<Stocks>(
                          builder: (context, stock, child) {
                            return InkWell(
                              onLongPress: () {
                                showUpdateStock(
                                  context,
                                  stocks: stock,
                                  cabang: cabangProvider.datas,
                                  idMakanan: makanan.id,
                                );
                              },
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsetsGeometry.all(5),
                                  child: Column(
                                    children: cabangProvider.datas.map((c) {
                                      final jumlah = stock.datas.firstWhere(
                                        (s) => s.idCabang == c.id,
                                        orElse: () => Stock(
                                          id: '',
                                          idCabang: c.id,
                                          idMakanan: makanan.id,
                                          jumlahStock: 0,
                                        ),
                                      );
                                      return Card(
                                        color: Colors.grey[200],
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 2,
                                            horizontal: 12,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(c.nama),
                                              Card(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 3,
                                                  ),
                                                  width: 75,
                                                  child: Text(
                                                    jumlah.jumlahStock
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            );
                          },
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
  }
}
