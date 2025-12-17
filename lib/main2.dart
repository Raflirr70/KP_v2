import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/distribusi.dart';
import 'package:kerprak/model/laporan.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/pengeluaran.dart';
// import 'package:kerprak/model/penjadwalan.dart';
import 'package:kerprak/model/penjualan.dart';
import 'package:kerprak/model/search.dart';
import 'package:kerprak/model/stock.dart';
import 'package:kerprak/model/user.dart';
import 'package:kerprak/screen/karyawan/homePage_karyawan.dart';
import 'package:kerprak/screen/login.dart';
import 'package:kerprak/screen/owner/homePage_admin.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Cabangs()),
        ChangeNotifierProvider(create: (_) => Users()),
        ChangeNotifierProvider(create: (_) => Makanans()),
        ChangeNotifierProvider(create: (_) => Stocks()),
        // ChangeNotifierProvider(create: (_) => Distribusis()),
        ChangeNotifierProvider(create: (_) => Laporans()),
        ChangeNotifierProvider(create: (_) => Pengeluarans()),
        // ChangeNotifierProvider(create: (_) => Penjadwalans()),
        ChangeNotifierProvider(create: (_) => Penjualans()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<Stocks>().getAllStocks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Monitoring Ampera",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Consumer<Stocks>(
            builder: (context, value, child) {
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<Stocks>(
                        context,
                        listen: false,
                      ).getStocksById("");
                    },

                    child: Text("data"),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: value.datas.length,
                      itemBuilder: (context, index) {
                        return Text(value.datas[index].jumlahStock.toString());
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
