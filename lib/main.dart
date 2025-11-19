import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/distribusi.dart';
import 'package:kerprak/model/laporan.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/pengeluaran.dart';
import 'package:kerprak/model/penjadwalan.dart';
import 'package:kerprak/model/penjualan.dart';
import 'package:kerprak/model/search.dart';
import 'package:kerprak/model/stock.dart';
import 'package:kerprak/model/user.dart';
import 'package:kerprak/screen/login.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Cabangs()),
        ChangeNotifierProvider(create: (_) => Users()),
        ChangeNotifierProvider(create: (_) => Makanans()),
        ChangeNotifierProvider(create: (_) => Stocks()),
        ChangeNotifierProvider(create: (_) => Distribusis()),
        ChangeNotifierProvider(create: (_) => Laporans()),
        ChangeNotifierProvider(create: (_) => Pengeluarans()),
        ChangeNotifierProvider(create: (_) => Penjadwalans()),
        ChangeNotifierProvider(create: (_) => Penjualans()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Monitoring Ampera",
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
