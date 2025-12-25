import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
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

  final String localVersion = "1.0.0";

  Future<Map<String, dynamic>> getServerData() async {
    final doc = await FirebaseFirestore.instance
        .collection('aplikasi')
        .doc('aplikasiversion')
        .get();

    return doc.data()!;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Monitoring Ampera",
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Map<String, dynamic>>(
        future: getServerData(),
        builder: (context, snapshot) {
          // ⏳ Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // ❌ Error
          if (snapshot.hasError || !snapshot.hasData) {
            return const Scaffold(
              body: Center(
                child: Text(
                  "Gagal mengecek versi aplikasi",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          }

          final serverVersion = snapshot.data!['version'];
          final downloadLink = snapshot.data!['link'];

          // 🚫 Versi tidak cocok
          if (serverVersion != localVersion) {
            return Scaffold(
              backgroundColor: Colors.grey[100],
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🖼️ GAMBAR
                      Image.asset(
                        "lib/asset/rumahGadang.png",
                        width: 120,
                        height: 120,
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        "Aplikasi Perlu Diperbarui",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Text(
                        "Versi aplikasi kamu: v$localVersion\n"
                        "Versi terbaru: v$serverVersion",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 28),

                      // 🔵 TOMBOL UPDATE
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.download),
                          label: const Text("Unduh Versi Terbaru"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            final uri = Uri.parse(downloadLink);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 12),

                      // 🔴 TOMBOL KELUAR
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.exit_to_app),
                          label: const Text("Keluar Aplikasi"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // ✅ Versi cocok → lanjut
          return AuthCheck();
        },
      ),
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
