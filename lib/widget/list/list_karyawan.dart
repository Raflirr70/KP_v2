import 'package:flutter/material.dart';
import 'package:kerprak/model/user.dart';
import 'package:kerprak/widget/popup/alert_penghapusan.dart';
import 'package:kerprak/widget/popup/show_tambah_karyawan.dart';
import 'package:provider/provider.dart';

class ListKaryawan extends StatelessWidget {
  final List<User> users;

  const ListKaryawan({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      itemCount: users.length + 1,
      itemBuilder: (context, i) {
        if (i == users.length) {
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
            onTap: () => showTambahKaryawanDialog(context),
          );
        }

        final user = users[i];

        return Card(
          elevation: 3,
          margin: EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showUserBottomSheet(context, user),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Text((i + 1).toString()),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow(Icons.person, "Nama", user.nama),
                        SizedBox(height: 6),
                        _infoRow(Icons.email, "Email", user.email),
                      ],
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

  void _showUserBottomSheet(BuildContext context, User user) {
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
                    _infoRow(Icons.person, "Nama", user.nama),
                    SizedBox(height: 8),
                    _infoRow(Icons.email, "Email", user.email),
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
                          await Provider.of<Users>(
                            context,
                            listen: false,
                          ).hapusKaryawan(user);
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
