import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';

Widget PilihanCabang(Cabangs cabang, int x) {
  return AlertDialog(
    title: const Text("Pilih Cabang"),
    content: SizedBox(
      width: double.maxFinite,
      height: 250, // tinggi fixed agar ListView bisa scroll
      child: ListView.builder(
        itemCount: cabang.datas.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(cabang.datas[index].nama),
              onTap: () {
                Navigator.pop(context, cabang.datas[index]);
              },
            ),
          );
        },
      ),
    ),
  );
}
