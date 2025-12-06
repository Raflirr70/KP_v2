// 1️⃣ Buat halaman baru untuk bottom sheet
import 'package:flutter/material.dart';
import 'package:kerprak/model/user.dart';
import 'package:kerprak/widget/popup/alert_penghapusan.dart';
import 'package:provider/provider.dart';

class KaryawanDetailPage extends StatelessWidget {
  final User user;
  const KaryawanDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indikator atas
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 15),

          // Info user
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  _infoRow(Icons.person, "Nama", user.nama),
                  SizedBox(height: 8),
                  _infoRow(Icons.email, "Email", user.email),
                ],
              ),
            ),
          ),

          SizedBox(height: 12),

          // Tombol Edit
          _actionButton(
            icon: Icons.edit,
            label: "Edit",
            color: Colors.blueAccent,
            onTap: () {
              Navigator.pop(context);
              print("Edit ${user.nama}");
            },
          ),
          SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _actionButton(
                  icon: Icons.lock_reset_outlined,
                  label: "Reset",
                  color: Colors.deepOrange,
                  onTap: () {
                    Navigator.pop(context);
                    alertPenghapusan(context, onDelete: () {});
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
                    alertPenghapusan(
                      context,
                      onDelete: () async {
                        // 1️⃣ Hapus data
                        await Provider.of<Users>(
                          context,
                          listen: false,
                        ).hapusKaryawan(user);
                        // 2️⃣ Tutup modal / alert
                        Navigator.pop(context);
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
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14),
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
