import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/jadwal.dart';
import 'package:kerprak/model/user.dart';
import 'package:provider/provider.dart';

class ListPenjadwalan extends StatelessWidget {
  final List<Cabang> value;
  ListPenjadwalan({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer2<Users, Jadwals>(
        builder: (context, user, jadwal, child) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            itemCount: value.length,
            itemBuilder: (context, index) {
              final cab = value[index];

              /// Filter jadwal sesuai cabang
              final filter = jadwal.getByCabang(cab.id);

              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Cabang
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        cab.nama,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Daftar karyawan
                    Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      child: Column(
                        children: filter.map((jad) {
                          final kar = user.datas.firstWhere(
                            (u) => u.id == jad.id_user,
                          );

                          return Card(
                            color: Colors.amber[200],
                            child: ListTile(
                              title: Text(kar.nama),
                              trailing: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Hapus karyawan ini?"),
                                        content: Text(
                                          "Tindakan tidak dapat dibatalkan.",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("Batal"),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            onPressed: () {
                                              jadwal.deleteById(jad.id);
                                              Navigator.pop(context);
                                            },
                                            child: Text("Hapus"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Icon(Icons.close, color: Colors.red),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // Tambah Karyawan
                    ListTile(
                      leading: Icon(Icons.add),
                      title: Text("Tambah Karyawan"),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            String? selectedUser;

                            // 🔥 Ambil semua jadwal dari semua cabang
                            final semuaJadwal = jadwal.datas;
                            final sudahAda = semuaJadwal
                                .map((j) => j.id_user)
                                .toSet()
                                .toList();

                            // 🔥 Filter user yang BELUM punya jadwal sama sekali
                            var dataKaryawan = user.datas
                                .where((u) => !sudahAda.contains(u.id))
                                .toList();

                            return AlertDialog(
                              title: Text("Pilih Karyawan"),
                              backgroundColor: Colors.orange[50],

                              content: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: "Karyawan",
                                ),
                                items: dataKaryawan
                                    .map(
                                      (kar) => DropdownMenuItem(
                                        value: kar.id,
                                        child: Text(kar.nama),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) => selectedUser = val,
                              ),

                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Batal"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    if (selectedUser != null) {
                                      jadwal.addJadwal(
                                        idUser: selectedUser!,
                                        idCabang: cab.id,
                                        nominal: 0,
                                        tanggal: DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day,
                                        ),
                                      );
                                    }

                                    Navigator.pop(context);
                                  },
                                  child: Text("Simpan"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
