import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/jadwal.dart';
import 'package:kerprak/model/penggajian.dart';
import 'package:kerprak/model/user.dart';
import 'package:kerprak/widget/popup/show_edit_penggajian.dart';
import 'package:provider/provider.dart';

class ListGajiKaryawan extends StatelessWidget {
  final List<Cabang> value;
  ListGajiKaryawan({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      itemCount: value.length,
      itemBuilder: (context, i) {
        return Card(
          color: Colors.grey[300],
          elevation: 5,
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text((i + 1).toString()),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        width: 2,
                        height: 25,
                        color: Colors.grey,
                      ),
                      Text(value[i].nama),
                    ],
                  ),
                  SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    color: Colors.grey[400],
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Consumer3<Users, Jadwals, Penggajians>(
                        builder: (context, user, jadwal, penggajian, child) {
                          // Filter schedule data based on the branch
                          final filter = jadwal.datas
                              .where((j) => j.id_cabang == value[i].id)
                              .toList();
                          // return Text(jadwal.datas.length.toString());
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: filter
                                .length, // Make sure this is the filtered count
                            itemBuilder: (context, index) {
                              final filkar = user.datas.firstWhere(
                                (u) => u.id == filter[index].id_user,
                              );

                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 4),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 3,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        filkar.nama, // Display user's name,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Spacer(),
                                      Text("Rp"),
                                      InkWell(
                                        onTap: () {
                                          showPenggajianKaryawanDialog(
                                            context,
                                            filkar.id,
                                            filter[index].id,
                                          );
                                        },
                                        child: Card(
                                          color: filter[index].nominal == 0
                                              ? Colors.red[100]
                                              : Colors.green[100],
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 16,
                                            ),
                                            width: 100,
                                            child: Text(
                                              filter[index].nominal.toString(),
                                              textAlign: TextAlign.end,
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
