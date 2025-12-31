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
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

// Hanya untuk mobile/desktop
import 'dart:io' show File;
import 'package:path_provider/path_provider.dart';

// Hanya untuk web
// import 'dart:html' as html;

import 'package:provider/provider.dart';

class DetailLaporan extends StatefulWidget {
  final dynamic laporan;
  const DetailLaporan({super.key, required this.laporan});

  static const double colNama = 80;
  static const double colHarga = 40;
  static const double colCabang = 50;
  static const double colTotal = 35;
  static const double colTotalRp = 50;

  static const BorderSide _border = BorderSide(color: Colors.grey, width: 0.4);

  @override
  State<DetailLaporan> createState() => _DetailLaporanState();
}

class _DetailLaporanState extends State<DetailLaporan> {
  final List<String> daftarCabang = const [
    "Cimacan",
    "Cipanas",
    "GSP",
    "Balakang",
    "Gudang",
  ];

  @override
  void initState() {
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

  // ===================== FORMAT UANG =====================
  String formatRupiah(int value) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  // ===================== BUILD =====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Laporan ${widget.laporan.id}",
          style: const TextStyle(fontSize: 14),
        ),
        centerTitle: true,
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
                Navigator.of(context).pop();
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
          ],
        ),
      ),
    );
  }

  // ===================== HEADER =====================
  Widget _headerSummary() {
    return Consumer3<Penjualans, Jadwals, Pengeluarans>(
      builder: (context, penjualan, jadwal, pengeluaran, child) {
        int totalPendapatan = 0, totalPengeluaran = 0, labaBersih = 0;

        for (int a = 0; a < penjualan.datas.length; a++) {
          totalPendapatan += penjualan.datas[a].totalHarga;
        }
        for (int a = 0; a < jadwal.datas.length; a++) {
          totalPengeluaran += jadwal.datas[a].nominal;
        }
        for (int a = 0; a < pengeluaran.datas.length; a++) {
          totalPengeluaran += pengeluaran.datas[a].totalHarga;
        }
        return Row(
          children: [
            _summaryCard(
              title: "Pendapatan",
              value: "Rp ${formatRupiah(totalPendapatan)}",
              color: Colors.green,
              icon: Icons.trending_up,
            ),
            const SizedBox(width: 6),
            _summaryCard(
              title: "Pengeluaran",
              value: "Rp ${formatRupiah(totalPengeluaran)}",
              color: Colors.red,
              icon: Icons.trending_down,
            ),
            const SizedBox(width: 6),
            _summaryCard(
              title: "Laba Bersih",
              value: "Rp ${formatRupiah(labaBersih)}",
              color: Colors.blue,
              icon: Icons.account_balance_wallet,
            ),
          ],
        );
      },
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
        int total = jadwal.datas.fold(0, (sum, e) => sum + e.nominal);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitleWithValue(
              "Jadwal Karyawan",
              "Rp ${formatRupiah(total)}",
            ),
            Card(
              child: Column(
                children: [
                  _jadwalHeader(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                            "Rp ${formatRupiah(jadwal.datas[index].nominal)}",
                          );
                        }
                      }
                      return const SizedBox();
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
            int rowIndex = 0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitleWithValue(
                  "Penjualan",
                  "Rp ${formatRupiah(penjualanProvider.Pendapatan())}",
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
                                List<String> jumlahPerCabang = [];
                                int totalPorsi = 0;
                                int totalHarga = 0;

                                for (var cabang in cabangProvider.datas) {
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
                                  harga: formatRupiah(makanan.harga),
                                  cabang: jumlahPerCabang,
                                  total: totalPorsi.toString(),
                                  totalHarga: formatRupiah(totalHarga),
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
    required int index,
  }) {
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
            : (l == "l" ? TextAlign.left : TextAlign.right),
        style: const TextStyle(fontSize: 8),
      ),
    );
  }

  // ===================== PENGELUARAN =====================
  Widget _pengeluaranSection() {
    return Consumer2<Pengeluarans, Cabangs>(
      builder: (context, pengeluaranProvider, cabangProvider, child) {
        Map<String, List<Pengeluaran>> pengeluaranPerCabang = {};
        for (var p in pengeluaranProvider.datas) {
          pengeluaranPerCabang.putIfAbsent(p.idCabang, () => []).add(p);
        }
        int total = pengeluaranProvider.datas.fold(
          0,
          (sum, p) => sum + p.totalHarga,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitleWithValue(
              "Pengeluaran",
              "Rp ${formatRupiah(total)}",
              valueColor: Colors.red,
            ),
            Card(
              child: Column(
                children: [
                  for (var cabang in cabangProvider.datas) ...[
                    if (pengeluaranPerCabang[cabang.id] != null) ...[
                      Container(
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: Text(
                          cabang.nama,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      for (var p in pengeluaranPerCabang[cabang.id]!) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          child: Row(
                            children: [
                              Text(
                                p.namaPengeluaran,
                                style: const TextStyle(fontSize: 10),
                              ),
                              const Spacer(),
                              Text(
                                "Rp ${formatRupiah(p.totalHarga)}",
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 0),
                      ],
                    ],
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // ===================== UTIL =====================
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

  // ===================== PDF EXPORT =====================
  Future<void> _downloadPDF() async {
    final pdf = pw.Document();

    final penjualans = Provider.of<Penjualans>(context, listen: false);
    final pengeluarans = Provider.of<Pengeluarans>(context, listen: false);
    final jadwals = Provider.of<Jadwals>(context, listen: false);
    final users = Provider.of<Users>(context, listen: false);
    final cabangs = Provider.of<Cabangs>(context, listen: false);
    final makanans = Provider.of<Makanans>(context, listen: false);

    int totalPendapatan = penjualans.Pendapatan();
    int totalPengeluaran = pengeluarans.datas.fold(
      0,
      (sum, p) => sum + p.totalHarga,
    );
    int totalGaji = jadwals.datas.fold(0, (sum, p) => sum + p.nominal);
    int labaBersih = totalPendapatan - (totalPengeluaran + totalGaji);

    const double fontSize = 8;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(15),
        build: (context) {
          return [
            pw.Center(
              child: pw.Text(
                "Laporan ${widget.laporan.id}",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Column(
              children: [
                pw.Row(
                  children: [
                    pw.SizedBox(
                      width: 80,
                      child: pw.Text(
                        "Pendapatan",
                        style: pw.TextStyle(fontSize: fontSize),
                      ),
                    ),
                    pw.Text(": Rp", style: pw.TextStyle(fontSize: fontSize)),
                    pw.SizedBox(
                      width: 50,
                      child: pw.Text(
                        formatRupiah(totalPendapatan),
                        textAlign: pw.TextAlign.end,
                        style: pw.TextStyle(fontSize: fontSize),
                      ),
                    ),
                  ],
                ),
                pw.Row(
                  children: [
                    pw.SizedBox(
                      width: 80,
                      child: pw.Text(
                        "Pengeluaran",
                        style: pw.TextStyle(fontSize: fontSize),
                      ),
                    ),
                    pw.Text(": Rp", style: pw.TextStyle(fontSize: fontSize)),
                    pw.SizedBox(
                      width: 50,
                      child: pw.Text(
                        formatRupiah(totalPengeluaran),
                        textAlign: pw.TextAlign.end,
                        style: pw.TextStyle(fontSize: fontSize),
                      ),
                    ),
                  ],
                ),
                pw.Row(
                  children: [
                    pw.SizedBox(
                      width: 80,
                      child: pw.Text(
                        "Gaji",
                        style: pw.TextStyle(fontSize: fontSize),
                      ),
                    ),
                    pw.Text(": Rp", style: pw.TextStyle(fontSize: fontSize)),
                    pw.SizedBox(
                      width: 50,
                      child: pw.Text(
                        formatRupiah(totalGaji),
                        textAlign: pw.TextAlign.end,
                        style: pw.TextStyle(fontSize: fontSize),
                      ),
                    ),
                  ],
                ),
                pw.Row(
                  children: [
                    pw.SizedBox(
                      width: 80,
                      child: pw.Text(
                        "Laba Bersih",
                        style: pw.TextStyle(fontSize: fontSize),
                      ),
                    ),
                    pw.Text(": Rp", style: pw.TextStyle(fontSize: fontSize)),
                    pw.SizedBox(
                      width: 50,
                      child: pw.Text(
                        formatRupiah(labaBersih),
                        textAlign: pw.TextAlign.end,
                        style: pw.TextStyle(fontSize: fontSize),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 10),

            // ==== Penjualan ====
            pw.Text(
              "Penjualan",
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
            pw.SizedBox(height: 3),
            pw.Table.fromTextArray(
              headers: [
                "Makanan",
                "Harga",
                ...cabangs.datas.map((c) => c.nama),
                "Total Porsi",
                "Total Rp",
              ],
              data: [
                for (var m in makanans.datas)
                  [
                    m.nama,
                    formatRupiah(m.harga),
                    for (var c in cabangs.datas)
                      penjualans.datas
                          .where((p) => p.id_cabang == c.id)
                          .map((p) {
                            var detail = p.detail.firstWhere(
                              (d) => d.id_makanan == m.id,
                              orElse: () => DetailPenjualan(
                                id: "",
                                id_makanan: "",
                                jumlah: 0,
                                totalHarga: 0,
                              ),
                            );
                            return detail.jumlah.toString();
                          })
                          .fold<int>(0, (prev, e) => prev + int.parse(e))
                          .toString(),
                    penjualans.datas
                        .map((p) {
                          var detail = p.detail.firstWhere(
                            (d) => d.id_makanan == m.id,
                            orElse: () => DetailPenjualan(
                              id: "",
                              id_makanan: "",
                              jumlah: 0,
                              totalHarga: 0,
                            ),
                          );
                          return detail.jumlah;
                        })
                        .fold<int>(0, (a, b) => a + b)
                        .toString(),
                    formatRupiah(
                      penjualans.datas
                          .map((p) {
                            var detail = p.detail.firstWhere(
                              (d) => d.id_makanan == m.id,
                              orElse: () => DetailPenjualan(
                                id: "",
                                id_makanan: "",
                                jumlah: 0,
                                totalHarga: 0,
                              ),
                            );
                            return detail.totalHarga;
                          })
                          .fold<int>(0, (a, b) => a + b),
                    ),
                  ],
              ],
              cellAlignment: pw.Alignment.center,
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: fontSize,
              ),
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              border: pw.TableBorder.all(color: PdfColors.grey),
              cellStyle: pw.TextStyle(fontSize: fontSize),
              cellHeight: 15,
            ),

            // ==== Jadwal Karyawan ====
            pw.SizedBox(height: 10),
            pw.Text(
              "Jadwal Karyawan",
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
            pw.Table.fromTextArray(
              headers: ["Nama", "Cabang", "Gaji"],
              data: [
                for (var jadwal in jadwals.datas)
                  for (var user in users.datas)
                    if (user.id == jadwal.id_user)
                      [
                        user.nama,
                        cabangs.datas
                            .firstWhere(
                              (c) => c.id == jadwal.id_cabang,
                              orElse: () => Cabang(id: "", nama: "Unknown"),
                            )
                            .nama,
                        formatRupiah(jadwal.nominal),
                      ],
              ],
              cellAlignment: pw.Alignment.centerLeft,
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: fontSize,
              ),
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              border: pw.TableBorder.all(color: PdfColors.grey),
              cellStyle: pw.TextStyle(fontSize: fontSize),
              cellHeight: 15,
            ),

            // ==== Pengeluaran ====
            pw.SizedBox(height: 10),
            pw.Text(
              "Pengeluaran",
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
            for (var cabang in cabangs.datas) ...[
              pw.Text(
                cabang.nama,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
              pw.Table.fromTextArray(
                headers: ["Nama Pengeluaran", "Total Rp"],
                data: [
                  for (var p in pengeluarans.datas.where(
                    (e) => e.idCabang == cabang.id,
                  ))
                    [p.namaPengeluaran, formatRupiah(p.totalHarga)],
                ],
                cellAlignment: pw.Alignment.centerLeft,
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: fontSize,
                ),
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                border: pw.TableBorder.all(color: PdfColors.grey),
                cellStyle: pw.TextStyle(fontSize: fontSize),
                cellHeight: 15,
              ),
              pw.SizedBox(height: 5),
            ],
          ];
        },
      ),
    );

    final bytes = await pdf.save();

    // final dir = await getApplicationDocumentsDirectory();
    // final file = File("${dir.path}/Laporan_$safeDate.pdf");
    // await file.writeAsBytes(bytes);
    // print("PDF berhasil disimpan di: ${file.path}");

    final dir = await getExternalStorageDirectory();
    final safeDate = widget.laporan.tanggal.toString().replaceAll('/', '-');
    final downloadPath = "${dir!.path}/Laporan_$safeDate.pdf";
    final file = File(downloadPath);
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);

    print("PDF berhasil disimpan di: $downloadPath");
  }
}
