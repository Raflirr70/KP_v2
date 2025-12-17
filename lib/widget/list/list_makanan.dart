import 'package:flutter/material.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/widget/popup/show_edit_makanan_dialog.dart';
import 'package:kerprak/widget/popup/show_tambah_makanan.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ListMakanan extends StatelessWidget {
  List<Makanan> value;
  ListMakanan({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: 70,
            width: double.infinity,
            child: InkWell(
              child: Card(
                color: Colors.lightBlue[100],
                elevation: 3,
                margin: EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Icon(Icons.add_circle),
                ),
              ),
              onTap: () => showTambahMakananDialog(context),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, i) {
                var nama = value[i].nama;

                // Ambil objek makanan sesuai nama hasil filter
                var makanan = value.firstWhere((u) => u.nama == nama);

                return Card(
                  elevation: 5,
                  child: InkWell(
                    onTap: () => _showMakananBottomSheet(context, makanan),

                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),
                      child: Row(
                        children: [
                          Text((i + 1).toString()),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            width: 2,
                            height: 25,
                            color: Colors.grey,
                          ),

                          // Nama Makanan
                          Text(
                            nama,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Spacer(),

                          // Harga berdasarkan makanan yang cocok
                          Text('Rp.${makanan.harga}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
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
                showEditMakananDialog(context, makanan);
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
