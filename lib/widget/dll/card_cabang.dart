import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:provider/provider.dart';

class PilihanCabangDialog extends StatelessWidget {
  final bool pilihDari; // true = dari, false = tujuan

  const PilihanCabangDialog({super.key, required this.pilihDari});

  @override
  Widget build(BuildContext context) {
    final cabangs = Provider.of<Cabangs>(context).datas;

    return AlertDialog(
      title: Text("Pilih Cabang ${pilihDari ? 'Asal' : 'Tujuan'}"),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: ListView.builder(
          itemCount: cabangs.length,
          itemBuilder: (context, i) {
            final cab = cabangs[i];

            return ListTile(
              title: Text(cab.nama),
              leading: cab.nama != "Gudang"
                  ? Icon(Icons.storefront_rounded)
                  : Icon(Icons.collections_bookmark),
              onTap: () {
                Navigator.pop(context, cab.id);
              },
            );
          },
        ),
      ),
    );
  }
}
