import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kerprak/model/konsumsi.dart';

class Laporan {
  String id; // pakai string supaya aman dengan Firestore auto-id
  String? id_penjualan;
  String? id_pengeluaran;
  bool status;
  DateTime? tanggal;
  String? id_cabang; // tambah field cabang

  Laporan({
    required this.id,
    this.id_penjualan,
    this.id_pengeluaran,
    this.status = false,
    this.tanggal,
    this.id_cabang,
  });

  factory Laporan.fromMap(String docId, Map<String, dynamic> map) {
    return Laporan(
      id: docId,
      id_penjualan: map['id_penjualan'],
      id_pengeluaran: map['id_pengeluaran'],
      status: map['status'] ?? false,
      tanggal: map['tanggal'] != null
          ? (map['tanggal'] is Timestamp
                ? (map['tanggal'] as Timestamp).toDate()
                : DateTime.parse(map['tanggal']))
          : null,
      id_cabang: map['id_cabang'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_penjualan': id_penjualan,
      'id_pengeluaran': id_pengeluaran,
      'status': status,
      'tanggal': tanggal != null ? Timestamp.fromDate(tanggal!) : null,
      'id_cabang': id_cabang,
    };
  }
}

class Laporans extends ChangeNotifier {
  final List<Laporan> _datas = [];
  List<Laporan> get datas => _datas;

  /// Ambil semua data laporan untuk cabang tertentu
  Future<void> getData(String idCabang) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("laporan")
          .where('id_cabang', isEqualTo: idCabang)
          .get();

      _datas.clear();
      _datas.addAll(
        snapshot.docs
            .map((doc) => Laporan.fromMap(doc.id, doc.data()))
            .toList(),
      );

      notifyListeners();
    } catch (e) {
      print("Error getData Laporan: $e");
    }
  }

  Future<void> getAllData() async {
    try {
      final laporanSnap = await FirebaseFirestore.instance
          .collection("laporan")
          .get();

      /// Map: yyyy-mm-dd -> {pendapatan, pengeluaran}
      final Map<String, int> pendapatanHarian = {};
      final Map<String, int> pengeluaranHarian = {};
      final Map<String, DateTime> tanggalMap = {};

      for (var doc in laporanSnap.docs) {
        final laporan = Laporan.fromMap(doc.id, doc.data());
        if (laporan.tanggal == null) continue;

        final dateKey =
            "${laporan.tanggal!.year}-${laporan.tanggal!.month}-${laporan.tanggal!.day}";

        tanggalMap[dateKey] ??= DateTime(
          laporan.tanggal!.year,
          laporan.tanggal!.month,
          laporan.tanggal!.day,
        );

        pendapatanHarian[dateKey] ??= 0;
        pengeluaranHarian[dateKey] ??= 0;

        // =====================
        // PENDAPATAN
        // =====================
        final penjualanSnap = await FirebaseFirestore.instance
            .collection("penjualan")
            .where("id_laporan", isEqualTo: laporan.id)
            .get();

        for (var p in penjualanSnap.docs) {
          pendapatanHarian[dateKey] =
              pendapatanHarian[dateKey]! + ((p['total_harga'] ?? 0) as int);
        }

        // =====================
        // PENGELUARAN
        // =====================
        final pengeluaranSnap = await FirebaseFirestore.instance
            .collection("pengeluaran")
            .where("id_laporan", isEqualTo: laporan.id)
            .get();

        for (var p in pengeluaranSnap.docs) {
          pengeluaranHarian[dateKey] =
              pengeluaranHarian[dateKey]! + ((p['total_harga'] ?? 0) as int);
        }

        final konsumsiSnap = await FirebaseFirestore.instance
            .collection("konsumsi")
            .where("id_laporan", isEqualTo: laporan.id)
            .get();

        for (var k in konsumsiSnap.docs) {
          pengeluaranHarian[dateKey] =
              pengeluaranHarian[dateKey]! + ((k['total_harga'] ?? 0) as int);
        }
      }

      // =====================
      // SIMPAN KE _datas
      // =====================
      _datas.clear();

      for (var key in tanggalMap.keys) {
        _datas.add(
          Laporan(
            id: key, // 🔥 dateKey
            tanggal: tanggalMap[key],
            id_penjualan: pendapatanHarian[key].toString(),
            id_pengeluaran: pengeluaranHarian[key].toString(),
          ),
        );
      }

      // urutkan terbaru
      _datas.sort((a, b) => b.tanggal!.compareTo(a.tanggal!));

      notifyListeners();
    } catch (e) {
      print("Error getAllData (harian): $e");
    }
  }

  Future<double> getPengeluaran(String idCabang) async {
    try {
      final now = DateTime.now();

      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      final snapshotCabang = await FirebaseFirestore.instance
          .collection("cabang")
          .doc(idCabang)
          .get();

      if (!snapshotCabang.exists) {
        return 0;
      }
      final snapshotLaporan = await FirebaseFirestore.instance
          .collection("laporan")
          .where('id_cabang', isEqualTo: idCabang)
          .where("tanggal", isGreaterThanOrEqualTo: startOfDay)
          .where("tanggal", isLessThan: endOfDay)
          .get();

      double totalPendapatan = 0;

      for (var laporanDoc in snapshotLaporan.docs) {
        final idLaporan = laporanDoc.id;

        final snapshotPenjualan = await FirebaseFirestore.instance
            .collection("pengeluaran")
            .where('id_laporan', isEqualTo: idLaporan)
            .get();

        for (var penjualan in snapshotPenjualan.docs) {
          totalPendapatan += (penjualan['total_harga'] ?? 0) as int;
        }
      }

      // 4️⃣ Output final
      return totalPendapatan;
    } catch (e) {
      print("Error getPendapatan: $e");
      return 0;
    }
  }

  Future<double> getPendapatan(String idCabang) async {
    try {
      final now = DateTime.now();

      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      // 1️⃣ Ambil data cabang
      final snapshotCabang = await FirebaseFirestore.instance
          .collection("cabang")
          .doc(idCabang)
          .get();

      if (!snapshotCabang.exists) {
        return 0;
      }

      // 2️⃣ Ambil laporan berdasarkan cabang
      final snapshotLaporan = await FirebaseFirestore.instance
          .collection("laporan")
          .where('id_cabang', isEqualTo: idCabang)
          .where("tanggal", isGreaterThanOrEqualTo: startOfDay)
          .where("tanggal", isLessThan: endOfDay)
          .get();

      double totalPendapatan = 0;

      // 3️⃣ Loop setiap laporan → ambil penjualan
      for (var laporanDoc in snapshotLaporan.docs) {
        final idLaporan = laporanDoc.id;

        final snapshotPenjualan = await FirebaseFirestore.instance
            .collection("penjualan")
            .where('id_laporan', isEqualTo: idLaporan)
            .get();

        for (var penjualan in snapshotPenjualan.docs) {
          totalPendapatan += (penjualan['total_harga'] ?? 0) as int;
        }
      }

      // 4️⃣ Output final
      return totalPendapatan;
    } catch (e) {
      print("Error getPendapatan: $e");
      return 0;
    }
  }

  Future<double> getTotalPengeluaran() async {
    try {
      final now = DateTime.now();

      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      // 2️⃣ Ambil laporan berdasarkan cabang
      final snapshotLaporan = await FirebaseFirestore.instance
          .collection("laporan")
          .where("tanggal", isGreaterThanOrEqualTo: startOfDay)
          .where("tanggal", isLessThan: endOfDay)
          .get();

      double totalPengeluaran = 0;

      // 3️⃣ Loop setiap laporan → ambil penjualan
      for (var laporanDoc in snapshotLaporan.docs) {
        final idLaporan = laporanDoc.id;

        final snapshotPenjualan = await FirebaseFirestore.instance
            .collection("pengeluaran")
            .where('id_laporan', isEqualTo: idLaporan)
            .get();

        for (var penjualan in snapshotPenjualan.docs) {
          totalPengeluaran += (penjualan['total_harga'] ?? 0) as int;
        }
      }

      // 4️⃣ Output final
      return totalPengeluaran;
    } catch (e) {
      print("Error getPengeluaran: $e");
      return 0;
    }
  }

  Future<double> getTotalPendapatan() async {
    try {
      final now = DateTime.now();

      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      // 2️⃣ Ambil laporan berdasarkan cabang
      final snapshotLaporan = await FirebaseFirestore.instance
          .collection("laporan")
          .where("tanggal", isGreaterThanOrEqualTo: startOfDay)
          .where("tanggal", isLessThan: endOfDay)
          .get();

      double totalPendapatan = 0;

      // 3️⃣ Loop setiap laporan → ambil penjualan
      for (var laporanDoc in snapshotLaporan.docs) {
        final idLaporan = laporanDoc.id;

        final snapshotPenjualan = await FirebaseFirestore.instance
            .collection("penjualan")
            .where('id_laporan', isEqualTo: idLaporan)
            .get();

        for (var penjualan in snapshotPenjualan.docs) {
          totalPendapatan += (penjualan['total_harga'] ?? 0) as int;
        }
      }

      // 4️⃣ Output final
      return totalPendapatan;
    } catch (e) {
      print("Error getPendapatan: $e");
      return 0;
    }
  }

  Future<Laporan?> getLaporanHariIni(String idCabang) async {
    try {
      final now = DateTime.now();

      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await FirebaseFirestore.instance
          .collection("laporan")
          .where("id_cabang", isEqualTo: idCabang)
          .where("tanggal", isGreaterThanOrEqualTo: startOfDay)
          .where("tanggal", isLessThan: endOfDay)
          .get();

      if (snapshot.docs.isEmpty) {
        return null; // tidak ada laporan hari ini
      }

      final doc = snapshot.docs.first;
      return Laporan.fromMap(doc.id, doc.data());
    } catch (e) {
      print("Error getLaporanHariIni: $e");
      return null;
    }
  }

  /// Tambah laporan ke list lokal
  void tambah(Laporan x) {
    _datas.add(x);
    notifyListeners();
  }

  /// Hapus laporan berdasarkan ID
  void hapus(String id) {
    _datas.removeWhere((l) => l.id == id);
    notifyListeners();
  }

  /// Total pendapatan semua laporan
  int totalPendapatan() {
    return _datas.fold(0, (sum, l) => sum);
  }

  /// Total pengeluaran semua laporan
  int totalPengeluaran() {
    return _datas.fold(0, (sum, l) => sum);
  }

  Future<String> checkAndCreateLaporan(String idCabang) async {
    // **LOAD DATA DULU**
    await getData(idCabang);

    final today = DateTime.now();

    final existingLaporan = _datas.where(
      (l) =>
          l.id_cabang == idCabang &&
          l.tanggal != null &&
          l.tanggal!.year == today.year &&
          l.tanggal!.month == today.month &&
          l.tanggal!.day == today.day,
    );

    if (existingLaporan.isNotEmpty) {
      return existingLaporan.first.id;
    }

    // buat baru
    final newRef = FirebaseFirestore.instance.collection("laporan").doc();

    final newData = Laporan(
      id: newRef.id,
      status: false,
      tanggal: today,
      id_cabang: idCabang,
    );

    await newRef.set(newData.toMap());
    tambah(newData);

    return newData.id;
  }

  Future<List<double>> getPendapatanHarianM({int jumlahHari = 14}) async {
    final now = DateTime.now();
    final startDate = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: jumlahHari - 1));

    // 1️⃣ Siapkan map tanggal -> total
    final Map<String, double> dailyTotals = {};

    for (int i = 0; i < jumlahHari; i++) {
      final date = startDate.add(Duration(days: i));
      final key = "${date.year}-${date.month}-${date.day}";
      dailyTotals[key] = 0;
    }

    // 2️⃣ Ambil laporan 14 hari
    final laporanSnap = await FirebaseFirestore.instance
        .collection("laporan")
        .where("tanggal", isGreaterThanOrEqualTo: startDate)
        .get();

    // 3️⃣ Loop laporan → ambil penjualan
    for (var laporanDoc in laporanSnap.docs) {
      final laporan = Laporan.fromMap(laporanDoc.id, laporanDoc.data());
      if (laporan.tanggal == null) continue;

      final key =
          "${laporan.tanggal!.year}-${laporan.tanggal!.month}-${laporan.tanggal!.day}";

      final penjualanSnap = await FirebaseFirestore.instance
          .collection("penjualan")
          .where("id_laporan", isEqualTo: laporan.id)
          .get();

      for (var p in penjualanSnap.docs) {
        dailyTotals[key] = (dailyTotals[key] ?? 0) + (p['total_harga'] ?? 0);
      }
    }

    // 4️⃣ Convert ke List<double> (dibagi 1000 untuk chart)
    return dailyTotals.values.map((e) => e / 1000).toList();
  }

  Future<List<double>> getPengeluaranHarianM({int jumlahHari = 14}) async {
    final now = DateTime.now();

    final startDate = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: jumlahHari - 1));

    // 1️⃣ Map tanggal -> total pengeluaran
    final Map<String, double> dailyTotals = {};

    for (int i = 0; i < jumlahHari; i++) {
      final date = startDate.add(Duration(days: i));
      final key = "${date.year}-${date.month}-${date.day}";
      dailyTotals[key] = 0;
    }

    // ================================
    // 2️⃣ AMBIL SEMUA GAJI SEKALI (HARlAN)
    // ================================
    final jadwalSnap = await FirebaseFirestore.instance
        .collection("jadwal")
        .where("tanggal", isGreaterThanOrEqualTo: startDate)
        .where(
          "tanggal",
          isLessThan: DateTime(now.year, now.month, now.day + 1),
        )
        .get();

    // Map: tanggal+cabang -> total gaji
    final Map<String, double> gajiHarianCabang = {};

    for (var g in jadwalSnap.docs) {
      final tgl = (g['tanggal'] as Timestamp).toDate();
      final dateKey = "${tgl.year}-${tgl.month}-${tgl.day}";
      final cabangKey = g['id_cabang'];

      final key = "$dateKey-$cabangKey";

      gajiHarianCabang[key] =
          (gajiHarianCabang[key] ?? 0) +
          ((g['nominal'] ?? 0) as num).toDouble();
    }

    // ================================
    // 3️⃣ AMBIL LAPORAN
    // ================================
    final laporanSnap = await FirebaseFirestore.instance
        .collection("laporan")
        .where("tanggal", isGreaterThanOrEqualTo: startDate)
        .get();

    for (var laporanDoc in laporanSnap.docs) {
      final laporan = Laporan.fromMap(laporanDoc.id, laporanDoc.data());
      if (laporan.tanggal == null) continue;

      final laporanDate = DateTime(
        laporan.tanggal!.year,
        laporan.tanggal!.month,
        laporan.tanggal!.day,
      );

      final dateKey =
          "${laporanDate.year}-${laporanDate.month}-${laporanDate.day}";

      // 🔹 Pengeluaran
      final pengeluaranSnap = await FirebaseFirestore.instance
          .collection("pengeluaran")
          .where("id_laporan", isEqualTo: laporan.id)
          .get();

      for (var p in pengeluaranSnap.docs) {
        dailyTotals[dateKey] =
            (dailyTotals[dateKey] ?? 0) +
            ((p['total_harga'] ?? 0) as num).toDouble();
      }

      // 🔹 Konsumsi
      final konsumsiSnap = await FirebaseFirestore.instance
          .collection("konsumsi")
          .where("id_laporan", isEqualTo: laporan.id)
          .get();

      for (var k in konsumsiSnap.docs) {
        dailyTotals[dateKey] =
            (dailyTotals[dateKey] ?? 0) +
            ((k['total_harga'] ?? 0) as num).toDouble();
      }

      // 🔹 Gaji (AMBIL DARI MAP, BUKAN QUERY ULANG)
      final gajiKey = "$dateKey-${laporan.id_cabang}";
      dailyTotals[dateKey] =
          (dailyTotals[dateKey] ?? 0) + (gajiHarianCabang[gajiKey] ?? 0);
    }

    // 4️⃣ Convert ke List<double (÷1000 untuk chart)
    return dailyTotals.values.map((e) => e / 1000).toList();
  }

  /// Total pendapatan per laporan
  Future<int> getPendapatanByLaporan(String idLaporan) async {
    final snap = await FirebaseFirestore.instance
        .collection("penjualan")
        .where("id_laporan", isEqualTo: idLaporan)
        .get();

    int total = 0;
    for (var d in snap.docs) {
      total += (d['total_harga'] ?? 0) as int;
    }
    return total;
  }

  /// Total pengeluaran per laporan
  Future<int> getPengeluaranByLaporan(String idLaporan) async {
    int total = 0;

    final pengeluaranSnap = await FirebaseFirestore.instance
        .collection("pengeluaran")
        .where("id_laporan", isEqualTo: idLaporan)
        .get();

    for (var d in pengeluaranSnap.docs) {
      total += (d['total_harga'] ?? 0) as int;
    }

    final konsumsiSnap = await FirebaseFirestore.instance
        .collection("konsumsi")
        .where("id_laporan", isEqualTo: idLaporan)
        .get();

    for (var d in konsumsiSnap.docs) {
      total += (d['total_harga'] ?? 0) as int;
    }

    return total;
  }
}
