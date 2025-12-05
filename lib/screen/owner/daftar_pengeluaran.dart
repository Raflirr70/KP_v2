// import 'package:flutter/material.dart';
// import 'package:kerprak/model/pengeluaran.dart';
// import 'package:kerprak/widget/list/list_pengeluaran.dart';
// import 'package:kerprak/widget/menu/dashboard_admin_menu.dart';
// import 'package:kerprak/widget/search/search_simple.dart';
// import 'package:provider/provider.dart';

// class DaftarPengeluaran extends StatefulWidget {
//   const DaftarPengeluaran({super.key});

//   @override
//   State<DaftarPengeluaran> createState() => _DaftarPengeluaranState();
// }

// class _DaftarPengeluaranState extends State<DaftarPengeluaran> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Daftar Pengeluaran"),
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => DashboardAdminMenu()),
//             );
//           },
//           icon: Icon(Icons.arrow_back_ios_new_sharp),
//         ),
//       ),
//       body: SafeArea(
//         child: Center(
//           child: Consumer<Pengeluarans>(
//             builder: (context, value, child) {
//               return Column(
//                 children: [
//                   // SearchSimple(
//                   //   data: value.datas.map((e) => e.nama_pengeluaran).toList(),
//                   // ),
//                   // SizedBox(height: 10, width: 250, child: Divider(height: 2)),
//                   // ListPengeluaran(value: value),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
