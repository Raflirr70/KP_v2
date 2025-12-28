import 'package:flutter/material.dart';

class DetailLaporan extends StatelessWidget {
  final laporan;
  const DetailLaporan({super.key, required this.laporan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Laporan")),
      body: Center(child: Text("Detail laporan untuk ${laporan.tanggal}")),
    );
  }
}
