import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppbarAdmin extends StatelessWidget {
  const AppbarAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(16), // atur radius sesukamu
      ),
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
                  Icon(Icons.temple_buddhist_outlined),
                  SizedBox(width: 5),
                  Text(
                    "Ampera Saiyo",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            Spacer(),
            Text(
              "Admin",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
            ),

            SizedBox(width: 10),
            InkWell(
              onTap: () async {
                final keluar = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Konfirmasi"),
                    content: Text("Apakah Anda yakin ingin keluar?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text("Batal"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text("Keluar"),
                      ),
                    ],
                  ),
                );

                if (keluar == true) {
                  FirebaseAuth.instance.signOut();
                }
              },

              child: Icon(Icons.logout, size: 20),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
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
