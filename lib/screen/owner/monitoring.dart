import 'package:flutter/material.dart';
import 'package:kerprak/model/laporan.dart';
import 'package:kerprak/widget/list/list_laporan.dart';
import 'package:kerprak/widget/menu/LineChartPendapatanAll.dart';
import 'package:kerprak/widget/menu/bar_chart_pendapatan_pengeluaran_cabang.dart';
import 'package:kerprak/widget/menu/laporan_harian.dart';
import 'package:kerprak/widget/navbar/appbar_admin.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

enum MonitoringType { keseluruhan, perhari, penjualan }

class Monitoring extends StatefulWidget {
  const Monitoring({super.key});

  @override
  State<Monitoring> createState() => _MonitoringState();
}

class _MonitoringState extends State<Monitoring> {
  MonitoringType _current = MonitoringType.keseluruhan;
  static const Color _primary = Color(0xff6c63ff);

  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppbarAdmin(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ================= TAB =================
            Row(
              children: [
                _monitoringTab(
                  title: "Keseluruhan",
                  type: MonitoringType.keseluruhan,
                ),
                _monitoringTab(title: "Per Hari", type: MonitoringType.perhari),
                _monitoringTab(
                  title: "Penjualan",
                  type: MonitoringType.penjualan,
                ),
              ],
            ),

            // ================= INPUT TANGGAL =================
            if (_current == MonitoringType.perhari) _datePicker(),

            // ================= CHART =================
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _buildChart(),
            ),

            // ================= LIST =================
            if (_current == MonitoringType.keseluruhan) ...[
              Expanded(
                child: FutureBuilder(
                  future: Provider.of<Laporans>(
                    context,
                    listen: false,
                  ).getAllData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return const ListLaporanWidget();
                  },
                ),
              ),
            ] else if (_current == MonitoringType.perhari) ...[
              Expanded(
                child: LaporanHarian(
                  key: ValueKey(_selectedDate ?? DateTime.now()),
                  time: _selectedDate ?? DateTime.now(),
                ),
              ),
            ] else
              Expanded(child: Text("Data Penjualan")),
          ],
        ),
      ),
    );
  }

  // ================= DATE PICKER =================
  Widget _datePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: InkWell(
        onTap: _pickDate,
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            border: Border.all(color: _primary),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, size: 18),
              const SizedBox(width: 10),
              Text(
                _selectedDate == null
                    ? "Pilih Tanggal"
                    : DateFormat('dd MMM yyyy').format(_selectedDate!),
                style: TextStyle(
                  color: _selectedDate == null ? Colors.grey : Colors.black,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });

      // 🔥 nanti bisa dipakai:
      // Provider.of<Laporans>(context, listen: false)
      //   .getDataByTanggal(picked);
    }
  }

  // ================= TAB WIDGET =================
  Widget _monitoringTab({required String title, required MonitoringType type}) {
    final bool isActive = _current == type;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _current = type;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 50,
          decoration: BoxDecoration(
            color: isActive ? _primary.withOpacity(0.15) : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isActive ? _primary : Colors.grey.shade300,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? _primary : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= CHART SWITCHER =================
  Widget _buildChart() {
    Widget chart;

    switch (_current) {
      case MonitoringType.keseluruhan:
        chart = const Linechartpendapatanall();
        break;
      case MonitoringType.perhari:
        chart = BarChartPendapatanPengeluaranCabang(
          time: _selectedDate ?? DateTime.now(),
        );
        break;
      case MonitoringType.penjualan:
        chart = const Linechartpendapatanall();
        break;
    }

    return Container(
      key: ValueKey(_current),
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: chart,
    );
  }
}

// ================= HELPER FORMAT =================
String formatShort(int value) {
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1)}M';
  } else if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(0)}k';
  } else {
    return value.toString();
  }
}
