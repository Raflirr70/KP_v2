import 'package:flutter/material.dart';
import 'package:kerprak/model/penggajian.dart';
import 'package:kerprak/widget/dll/inforow.dart';
import 'package:provider/provider.dart';
import 'package:kerprak/model/user.dart';

void showPenggajianKaryawanDialog(
  BuildContext context,
  String idPegawai,
  String idLaporan,
) {
  final _formKey = GlobalKey<FormState>();
  int gajiBaru = 0;

  final user = Provider.of<Users>(context, listen: false);
  final pegawai = user.datas.firstWhere((u) => u.id == idPegawai);

  // ----------------------------
  // 🔥 Ambil data gaji lama
  // ----------------------------
  final penggajians = Provider.of<Penggajians>(context, listen: false);

  final dataGaji = penggajians.datas.firstWhere(
    (g) => g.id_pegawai == idPegawai && g.id_laporan == idLaporan,
    orElse: () => Penggajian(
      id: '',
      id_pegawai: idPegawai,
      id_laporan: idLaporan,
      gaji: 0,
    ),
  );

  int gajiLama = dataGaji.gaji;

  // Controller agar otomatis muncul gaji lama
  final gajiController = TextEditingController(text: gajiLama.toString());

  // ----------------------------

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama Pegawai
                infoRow(Icons.people, "Nama", pegawai.nama),

                SizedBox(height: 20),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: gajiController,
                        decoration: InputDecoration(
                          labelText: "Masukan Gaji",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.money),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Gaji tidak boleh kosong";
                          }
                          if (int.tryParse(value) == null) {
                            return "Masukkan angka yang benar";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          gajiBaru = int.tryParse(value) ?? gajiLama;
                        },
                      ),

                      SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final messenger = ScaffoldMessenger.of(context);

                                await Provider.of<Penggajians>(
                                  context,
                                  listen: false,
                                ).simpanGaji(idPegawai, idLaporan, gajiBaru);

                                Navigator.pop(context);

                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text("Berhasil disimpan"),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Gagal : $e"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          child: Text("Simpan"),
                        ),
                      ),
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
