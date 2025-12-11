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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.orange[50],
      insetPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      title: Text(
        "Pilih Cabang ${pilihDari ? 'Asal' : 'Tujuan'}",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),

      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: ListView.separated(
          itemCount: cabangs.length,
          separatorBuilder: (context, i) =>
              Divider(height: 1, color: Colors.black26),
          itemBuilder: (context, i) {
            final cab = cabangs[i];
            return ListTile(
              dense: true, // lebih compact
              title: Text(cab.nama),
              leading: cab.nama != "Gudang"
                  ? Icon(Icons.storefront_rounded, color: Colors.orange)
                  : Icon(Icons.collections_bookmark, color: Colors.orange),
              hoverColor: Colors.orange[100], // efek hover di desktop/web
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
