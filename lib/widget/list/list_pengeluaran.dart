import 'package:flutter/material.dart';
import 'package:kerprak/model/pengeluaran.dart';
import 'package:kerprak/widget/popup/alert_penghapusan.dart';
import 'package:kerprak/widget/popup/show_edit_pengeluaran.dart';
import 'package:kerprak/widget/popup/show_tambah_pengeluaran.dart';
import 'package:provider/provider.dart';

class ListPengeluaran extends StatelessWidget {
  final List<Pengeluaran> pluars;
  ListPengeluaran({super.key, required this.pluars});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      itemCount: pluars.length + 1,
      itemBuilder: (context, i) {
        if (i == pluars.length) {
          return InkWell(
            child: Card(
              color: Colors.lightBlue[100],
              elevation: 3,
              margin: EdgeInsets.only(bottom: 12),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Icon(Icons.add_circle),
              ),
            ),
            onTap: () => showTambahPengeluaranPopup(context),
          );
        }

        var pluar = pluars[i];

        return Card(
          shape: RoundedRectangleBorder(),
          elevation: 5,
          child: InkWell(
            onTap: () {
              _showUserBottomSheet(context, pluar);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text((i + 1).toString()),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: 2,
                    height: 25,
                    color: Colors.grey, // bisa diganti
                  ),

                  Text(
                    pluar.namaPengeluaran,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 60,
                    child: Text("${pluar.jumlahUnit} ${pluar.jenisSatuan}"),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: 2,
                    height: 25,
                    color: Colors.grey, // bisa diganti
                  ),
                  Text("Rp "),
                  SizedBox(
                    width: 70,
                    child: Text(
                      '${pluar.totalHarga}',
                      textAlign: TextAlign.end,
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

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[700]),
        SizedBox(width: 10),
        SizedBox(width: 60, child: Text("$label")),
        Expanded(
          child: Text(
            ": $value",
            style: TextStyle(fontSize: 15, color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }

  void _showUserBottomSheet(BuildContext context, Pengeluaran pluar) {
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
                    _infoRow(Icons.person, "Nama", pluar.namaPengeluaran),
                    SizedBox(height: 8),
                    _infoRow(Icons.email, "Email", pluar.totalHarga.toString()),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    icon: Icons.edit,
                    label: "Edit",
                    color: Colors.blueAccent,
                    onTap: () {
                      Navigator.pop(context);
                      showEditPengeluaranPopup(context, pluar);
                    },
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: _actionButton(
                    icon: Icons.delete,
                    label: "Hapus",
                    color: Colors.redAccent,
                    onTap: () {
                      Navigator.pop(context);
                      alertPenghapusan(
                        context,
                        onDelete: () async {
                          await Provider.of<Pengeluarans>(
                            context,
                            listen: false,
                          ).hapusData(pluar);
                        },
                      );
                    },
                  ),
                ),
              ],
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
