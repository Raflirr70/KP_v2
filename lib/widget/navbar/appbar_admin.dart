import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kerprak/model/laporan.dart';
import 'package:provider/provider.dart';

class AppbarAdmin extends StatelessWidget {
  const AppbarAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Row(
                children: [
                  const Icon(Icons.temple_buddhist_outlined),
                  const SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Ampera Saiyo",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      /// 🔥 LABA ASYNC
                      FutureBuilder<double>(
                        future: context.read<Laporans>().getLaba(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text(
                              "Memuat...",
                              style: TextStyle(fontSize: 10),
                            );
                          }

                          final laba = snapshot.data ?? 0;

                          return Row(
                            children: [
                              laba.isNegative
                                  ? Icon(
                                      Icons.arrow_downward,
                                      color: Colors.red,
                                      size: 14,
                                    )
                                  : Icon(
                                      Icons.arrow_upward,
                                      color: Colors.green,
                                      size: 14,
                                    ),
                              Text(
                                "Rp ${laba.toStringAsFixed(0)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: laba.isNegative
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Text(
              "Admin",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () async {
                final keluar = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Konfirmasi"),
                    content: const Text("Apakah Anda yakin ingin keluar?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Batal"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Keluar"),
                      ),
                    ],
                  ),
                );

                if (keluar == true) {
                  FirebaseAuth.instance.signOut();
                }
              },
              child: const Icon(Icons.logout, size: 20),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }
}
