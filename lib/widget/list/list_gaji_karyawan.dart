import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/jadwal.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/search.dart';
import 'package:kerprak/model/user.dart';
import 'package:kerprak/widget/popup/show_tambah_makanan.dart';
import 'package:provider/provider.dart';

class ListGajiKaryawan extends StatelessWidget {
  final List<Cabang> value;
  ListGajiKaryawan({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      itemCount: value.length,
      itemBuilder: (context, i) {
        return Card(
          color: Colors.grey[300],
          elevation: 5,
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text((i + 1).toString()),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        width: 2,
                        height: 25,
                        color: Colors.grey,
                      ),
                      Text(value[i].nama),
                    ],
                  ),
                  SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    color: Colors.grey[400],
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Consumer2<Users, Jadwals>(
                        builder: (context, user, jadwal, child) {
                          // Filter schedule data based on the branch
                          final filter = jadwal.datas
                              .where((j) => j.id_cabang == value[i].id)
                              .toList();
                          // return Text(jadwal.datas.length.toString());
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: filter
                                .length, // Make sure this is the filtered count
                            itemBuilder: (context, index) {
                              final filkar = user.datas
                                  .where((u) => u.id == filter[index].id_user)
                                  .toList();
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 4),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    filkar.isNotEmpty
                                        ? filkar[0].nama
                                        : "User not found", // Display user's name
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[700]),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            ": $value",
            style: TextStyle(fontSize: 15, color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }

  void _showMakananBottomSheet(BuildContext context, Makanan makanan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      backgroundColor: Colors.white,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 15),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    _infoRow(Icons.fastfood, makanan.nama),
                    SizedBox(height: 8),
                    _infoRow(Icons.price_change, makanan.harga.toString()),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            _actionButton(
              icon: Icons.edit,
              label: "Edit",
              color: Colors.blueAccent,
              onTap: () {
                Navigator.pop(context);
                print("Edit ${makanan.nama}");
              },
            ),
            SizedBox(height: 12),

            _actionButton(
              icon: Icons.delete,
              label: "Hapus",
              color: Colors.redAccent,
              onTap: () async {
                Navigator.pop(context);
                await Provider.of<Makanans>(
                  context,
                  listen: false,
                ).hapusMakanan(makanan);
              },
            ),

            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
