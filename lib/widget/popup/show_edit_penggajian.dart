import 'package:flutter/material.dart';
import 'package:kerprak/model/jadwal.dart';
import 'package:kerprak/widget/dll/inforow.dart';
import 'package:provider/provider.dart';
import 'package:kerprak/model/user.dart';

void showPenggajianKaryawanDialog(
  BuildContext context,
  String idPegawai,
  String idJadwal,
) {
  final formKey = GlobalKey<FormState>();

  final usersProvider = Provider.of<Users>(context, listen: false);
  final jadwalsProvider = Provider.of<Jadwals>(context, listen: false);

  final pegawai = usersProvider.datas.firstWhere((u) => u.id == idPegawai);
  final jadwal = jadwalsProvider.datas.firstWhere((j) => j.id == idJadwal);

  final TextEditingController gajiController = TextEditingController(
    text: jadwal.nominal.toString(),
  );

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.orange[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 Info Pegawai
                infoRow(Icons.people, "Nama", pegawai.nama),
                const SizedBox(height: 20),

                /// 🔹 Form Gaji
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: gajiController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.end,
                        decoration: InputDecoration(
                          labelText: "Masukkan Gaji",
                          prefixIcon: const Icon(Icons.money),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Gaji tidak boleh kosong";
                          }
                          if (int.tryParse(value) == null) {
                            return "Masukkan angka yang valid";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      /// 🔹 Tombol Simpan
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (!formKey.currentState!.validate()) return;

                            try {
                              final gajiBaru = int.parse(gajiController.text);

                              await jadwalsProvider.updateNominal(
                                idJadwal,
                                gajiBaru,
                              );

                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Berhasil disimpan"),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Gagal: $e"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: const Text("Simpan"),
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
