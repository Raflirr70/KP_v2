import 'package:flutter/material.dart';
import 'package:kerprak/model/distribusi.dart';
import 'package:provider/provider.dart';

class ListDistribusi extends StatefulWidget {
  const ListDistribusi({super.key});

  @override
  State<ListDistribusi> createState() => _ListDistribusiState();
}

class _ListDistribusiState extends State<ListDistribusi> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Distribusis>(
      builder: (context, value, child) {
        return Expanded(
          child: ListView.builder(
            itemCount: value.datas.length + 1,
            itemBuilder: (context, index) {
              if (index != value.datas.length) {
                return InkWell(
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(value.datas[index].makanan.nama),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: Card(
                                    shape: RoundedRectangleBorder(),
                                    child: Text(value.datas[index].dari.nama),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Icon(Icons.arrow_right_alt, size: 30),
                                  Text(
                                    value.datas[index].jumlah.toString(),
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: Card(
                                    shape: RoundedRectangleBorder(),
                                    child: Text(value.datas[index].tujuan.nama),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    // showDialog(
                    //   context: context,
                    //   builder: (context) => editDaftar(context, index),
                    // );
                  },
                );
              } else {
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Card(
                    child: ListView(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.add, size: 30),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
