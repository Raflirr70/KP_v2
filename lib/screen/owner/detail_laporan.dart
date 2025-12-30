import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:kerprak/model/cabang.dart';
import 'package:kerprak/model/jadwal.dart';
import 'package:kerprak/model/makanan.dart';
import 'package:kerprak/model/pengeluaran.dart';
import 'package:kerprak/model/penjualan.dart';
import 'package:kerprak/model/user.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// Hanya untuk mobile/desktop
import 'dart:io' show File;
import 'package:path_provider/path_provider.dart';

// Hanya untuk web
import 'dart:html' as html;

import 'package:provider/provider.dart';

class DetailLaporan extends StatefulWidget {
  final dynamic laporan;
  const DetailLaporan({super.key, required this.laporan});

  static const double colNama = 80;
  static const double colHarga = 40;
  static const double colCabang = 50;
  static const double colTotal = 35;
  static const double colTotalRp = 50;

  // ===== BORDER =====
  static const BorderSide _border = BorderSide(color: Colors.grey, width: 0.4);

  @override
  State<DetailLaporan> createState() => _DetailLaporanState();
}

class _DetailLaporanState extends State<DetailLaporan> {
  // ===== DAFTAR CABANG =====
  final List<String> daftarCabang = const [
    "Cimacan",
    "Cipanas",
    "GSP",
    "Balakang",
    "Gudang",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Users>(context, listen: false).fetchData();
      Provider.of<Jadwals>(
        context,
        listen: false,
      ).getJadwalLaporan(widget.laporan.tanggal);
      Provider.of<Cabangs>(context, listen: false).getCabang();
      Provider.of<Makanans>(context, listen: false).getMakanan();
      Provider.of<Penjualans>(
        context,
        listen: false,
      ).getPenjualanByHari(hari: widget.laporan.tanggal);
      Provider.of<Pengeluarans>(
        context,
        listen: false,
      ).fetchDataLaporan(widget.laporan.tanggal);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Laporan ${widget.laporan.tanggal}",
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );

              try {
                await _downloadPDF();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("PDF berhasil dibuat!")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Gagal membuat PDF: $e")),
                );
              } finally {
                Navigator.of(context).pop(); // hilangkan loading
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerSummary(),
            const SizedBox(height: 24),
            _jadwalKaryawan(),
            const SizedBox(height: 24),
            _penjualanSection(),
            const SizedBox(height: 24),
            _pengeluaranSection(),
            const SizedBox(height: 24),
            _kesimpulanSection(),
          ],
        ),
      ),
    );
  }

  // ===================== HEADER =====================
  Widget _headerSummary() {
    return Row(
      children: [
        _summaryCard(
          title: "Pendapatan",
          value: "Rp 2.860.000",
          color: Colors.green,
          icon: Icons.trending_up,
        ),
        const SizedBox(width: 6),
        _summaryCard(
          title: "Pengeluaran",
          value: "Rp 167.000",
          color: Colors.red,
          icon: Icons.trending_down,
        ),
        const SizedBox(width: 6),
        _summaryCard(
          title: "Laba Bersih",
          value: "Rp 2.693.000",
          color: Colors.blue,
          icon: Icons.account_balance_wallet,
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 11)),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== JADWAL KARYAWAN =====================
  Widget _jadwalKaryawan() {
    return Consumer3<Jadwals, Users, Cabangs>(
      builder: (context, jadwal, user, cabang, child) {
        int total = 0;
        for (int a = 0; a < jadwal.datas.length; a++)
          total += jadwal.datas[a].nominal;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitleWithValue("Jadwal Karyawan", "Rp $total"),
            Card(
              child: Column(
                children: [
                  _jadwalHeader(),
                  ListView.builder(
                    shrinkWrap:
                        true, // penting agar ListView menyesuaikan tinggi isinya
                    physics:
                        const NeverScrollableScrollPhysics(), // biar scroll hanya di SingleChildScrollView parent
                    itemCount: jadwal.datas.length,
                    itemBuilder: (context, index) {
                      for (int a = 0; a < user.datas.length; a++) {
                        if (user.datas[a].id == jadwal.datas[index].id_user) {
                          String namaCabang = "s";
                          for (int b = 0; b < cabang.datas.length; b++) {
                            if (jadwal.datas[index].id_cabang ==
                                cabang.datas[b].id)
                              namaCabang = cabang.datas[b].nama;
                          }
                          return _jadwalRow(
                            user.datas[a].nama,
                            namaCabang,
                            "Rp ${jadwal.datas[index].nominal}",
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _jadwalHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.grey.shade200,
      child: const Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "Nama",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              "Cabang",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "Gaji",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _jadwalRow(String nama, String cabang, String gaji) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(nama, style: const TextStyle(fontSize: 11)),
          ),
          Expanded(
            flex: 3,
            child: Text(cabang, style: const TextStyle(fontSize: 11)),
          ),
          Expanded(
            flex: 2,
            child: Text(
              gaji,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ===================== PENJUALAN =====================
  Widget _penjualanSection() {
    return Consumer3<Makanans, Penjualans, Cabangs>(
      builder:
          (context, makananProvider, penjualanProvider, cabangProvider, child) {
            int rowIndex = 0; // counter untuk zebra striping
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitleWithValue(
                  "Penjualan",
                  "Rp ${penjualanProvider.Pendapatan()}",
                  valueColor: Colors.green,
                ),
                Card(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        _tableHeader(),
                        for (var makanan in makananProvider.datas)
                          if (makanan.nama != "Gudangs") ...[
                            Builder(
                              builder: (context) {
                                // Ambil jumlah per cabang
                                List<String> jumlahPerCabang = [];
                                int totalPorsi = 0;
                                int totalHarga = 0;

                                for (var cabang in cabangProvider.datas) {
                                  // cari Penjualan di cabang ini
                                  int jumlah = 0;
                                  int harga = 0;

                                  for (var p in penjualanProvider.datas.where(
                                    (p) => p.id_cabang == cabang.id,
                                  )) {
                                    var detail = p.detail.firstWhere(
                                      (d) => d.id_makanan == makanan.id,
                                      orElse: () => DetailPenjualan(
                                        id: "",
                                        id_makanan: "",
                                        jumlah: 0,
                                        totalHarga: 0,
                                      ),
                                    );
                                    jumlah += detail.jumlah;
                                    harga += detail.totalHarga;
                                  }

                                  jumlahPerCabang.add(jumlah.toString());
                                  totalPorsi += jumlah;
                                  totalHarga += harga;
                                }

                                return _tableRow(
                                  nama: makanan.nama,
                                  harga: makanan.harga.toString(),
                                  cabang: jumlahPerCabang,
                                  total: totalPorsi.toString(),
                                  totalHarga: totalHarga.toString(),
                                  index: rowIndex++,
                                );
                              },
                            ),
                          ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
    );
  }

  Widget _tableHeader() {
    return Container(
      color: Colors.grey.shade400,
      child: Row(
        children: [
          _headerCell("Makanan", DetailLaporan.colNama),
          _headerCell("Harga", DetailLaporan.colHarga),
          ...daftarCabang.map(
            (c) => _headerCell(c, DetailLaporan.colCabang, center: true),
          ),
          _headerCell("Total", DetailLaporan.colTotal),
          _headerCell("Total Rp", DetailLaporan.colTotalRp),
        ],
      ),
    );
  }

  Widget _tableRow({
    required String nama,
    required String harga,
    required List<String> cabang,
    required String total,
    required String totalHarga,
    required int index, // tambahkan index
  }) {
    // Warna latar untuk baris genap
    final bgColor = index % 2 == 1 ? Colors.grey.shade300 : Colors.white;

    return Container(
      color: bgColor,
      child: Row(
        children: [
          _cell(nama, DetailLaporan.colNama, "l"),
          _cell(harga, DetailLaporan.colHarga, "r"),
          ...cabang.map(
            (c) => _cell(c, DetailLaporan.colCabang, "l", center: true),
          ),
          _cell(total, DetailLaporan.colTotal, "l", center: true),
          _cell(totalHarga, DetailLaporan.colTotalRp, "r"),
        ],
      ),
    );
  }

  Widget _headerCell(String text, double width, {bool center = false}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        border: Border(right: DetailLaporan._border),
      ),
      child: Text(
        text,
        textAlign: center ? TextAlign.center : TextAlign.left,
        style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _cell(String text, double width, String l, {bool center = false}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        border: Border(right: DetailLaporan._border),
      ),
      child: Text(
        text,
        textAlign: center
            ? TextAlign.center
            : l == "l"
            ? TextAlign.left
            : TextAlign.right,
        style: const TextStyle(fontSize: 8),
      ),
    );
  }

  // ===================== PENGELUARAN =====================
  Widget _pengeluaranSection() {
    return Consumer<Pengeluarans>(
      builder: (context, pengeluaran, child) {
        print(
          "Pengeluaran ${pengeluaran.datas.length} ${widget.laporan.tanggal}",
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitleWithValue(
              "Pengeluaran",
              "Rp 167.000",
              valueColor: Colors.red,
            ),
            Card(
              child: Column(
                children: [
                  for (int a = 0; a < pengeluaran.datas.length; a++) ...[
                    ListTile(
                      title: Text(pengeluaran.datas[a].namaPengeluaran),
                      trailing: Text("Rp 150.000"),
                    ),
                    Divider(height: 0),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // ===================== KESIMPULAN =====================
  Widget _kesimpulanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Kesimpulan"),
        Card(
          color: Colors.green.shade50,
          child: const ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text(
              "Laba Bersih",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              "Rp 2.693.000",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===================== UTIL =====================
  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      title,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    ),
  );

  Widget _sectionTitleWithValue(
    String title,
    String value, {
    Color valueColor = Colors.black,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    ),
  );

  // ===================== PDF EXPORT CROSS-PLATFORM =====================
  Future<void> _downloadPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "Laporan ${widget.laporan.tanggal}",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Text("Pendapatan: Rp 2.860.000"),
            pw.Text("Pengeluaran: Rp 167.000"),
            pw.Text("Laba Bersih: Rp 2.693.000"),
            pw.SizedBox(height: 10),
            pw.Text(
              "Jadwal Karyawan",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Table.fromTextArray(
              headers: ["Nama", "Cabang", "Gaji"],
              data: [
                ["Budi", "Cimacan", "Rp 20.000"],
                ["Ani", "Cipanas", "Rp 20.000"],
                ["Doni", "GSP", "Rp 15.000"],
              ],
            ),
          ],
        ),
      ),
    );

    final bytes = await pdf.save();

    if (kIsWeb) {
      // Web download via Blob
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "Laporan_${widget.laporan.tanggal}.pdf")
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // Mobile/Desktop save to file
      final dir = await getApplicationDocumentsDirectory();
      final safeDate = widget.laporan.tanggal.toString().replaceAll('/', '-');
      final file = File("${dir.path}/Laporan_$safeDate.pdf");
      await file.writeAsBytes(bytes);
      print("PDF berhasil disimpan di: ${file.path}");
    }
  }
}
