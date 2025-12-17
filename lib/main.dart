import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/distribusi.dart';
import 'package:kerprak/model/jadwal.dart';
import 'package:kerprak/model/konsumsi.dart';
import 'package:kerprak/model/laporan.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/pengeluaran.dart';
import 'package:kerprak/model/penggajian.dart';
import 'package:kerprak/model/penjualan.dart';
import 'package:kerprak/model/search.dart';
import 'package:kerprak/model/stock.dart';
import 'package:kerprak/model/user.dart';
import 'package:kerprak/screen/karyawan/homePage_karyawan.dart';
import 'package:kerprak/screen/login.dart';
import 'package:kerprak/screen/owner/homePage_admin.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        ChangeNotifierProvider(create: (_) => Jadwals()),
        ChangeNotifierProvider(create: (_) => Users()),
        ChangeNotifierProvider(create: (_) => Makanans()),
        ChangeNotifierProvider(create: (_) => Stocks()),
        ChangeNotifierProvider(create: (_) => Penggajians()),
        ChangeNotifierProvider(create: (_) => Distribusis()),
        ChangeNotifierProvider(create: (_) => Laporans()),
        ChangeNotifierProvider(create: (_) => Pengeluarans()),
        ChangeNotifierProvider(create: (_) => Penjualans()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => Konsumsis()),
        // ChangeNotifierProvider(create: (_) => DetailKonsumsis()),
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
      home: AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LoginPage();

        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection("akun")
              .doc(snapshot.data!.uid)
              .get(),
          builder: (context, roleSnapshot) {
            // return Text("roleSnapshot.toString()");
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!roleSnapshot.hasData || !roleSnapshot.data!.exists) {
              return Center(child: Text("User tidak ditemukan"));
            }

            final data = roleSnapshot.data!.data();
            if (data == null) {
              return Center(child: Text("User tidak ditemukan"));
            }

            final role = data["role"];
            if (role == "admin") {
              return HomepageAdmin(nama: data["nama"]);
            } else {
              return HomepageKaryawan(id_user: snapshot.data!.uid);
            }
          },
        );
      },
    );
  }
}
