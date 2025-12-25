import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/user.dart';
import 'package:provider/provider.dart';

class AppbarKaryawan extends StatelessWidget {
  final id_cabang;
  const AppbarKaryawan({super.key, required this.id_cabang});

  @override
  Widget build(BuildContext context) {
    return Consumer2<Users, Cabangs>(
      builder: (context, user, cabang, child) {
        return ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
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
                      Icon(Icons.temple_buddhist_outlined, color: Colors.white),
                      SizedBox(width: 5),
                      Text(
                        cabang.datas.firstWhere((c) => c.id == id_cabang).nama,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      user.datas
                          .firstWhere(
                            (u) =>
                                u.id == FirebaseAuth.instance.currentUser!.uid,
                          )
                          .nama,
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    Text(
                      "Karyawan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.account_circle_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
