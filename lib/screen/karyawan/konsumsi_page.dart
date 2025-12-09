// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:kerprak/model/penjualan.dart';

// class KonsumsiPage extends StatefulWidget {
//   const KonsumsiPage({super.key});

//   @override
//   State<KonsumsiPage> createState() => _KonsumsiPageState();
// }

// class _KonsumsiPageState extends State<KonsumsiPage> {
//   bool _showSummary = true;
//   String formatTimeOfDay(TimeOfDay tod) {
//     final hour = tod.hourOfPeriod.toString().padLeft(2, '0');
//     final minute = tod.minute.toString().padLeft(2, '0');
//     final period = tod.period == DayPeriod.am ? "AM" : "PM";

//     return "$hour:$minute $period";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.grey[50], // Lebih lembut dari grey[100]
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(50),
//           child: ClipRRect(
//             borderRadius: BorderRadius.vertical(
//               bottom: Radius.circular(16), // atur radius sesukamu
//             ),
//             child: AppBar(
//               automaticallyImplyLeading: false,
//               backgroundColor: Colors.blueAccent,
//               title: Row(
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Row(
//                       children: [
//                         Icon(Icons.temple_buddhist_outlined),
//                         SizedBox(width: 5),
//                         Text(
//                           "Cipanas",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Spacer(),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text("Ujang Sopandi", style: TextStyle(fontSize: 10)),
//                       Text(
//                         "Karyawan",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 10,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(width: 5),
//                   InkWell(
//                     onTap: () {},
//                     child: Icon(Icons.account_circle_rounded, size: 30),
//                   ),
//                 ],
//               ),
//               flexibleSpace: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.blueAccent, Colors.lightBlueAccent],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),

//         body: Column(
//           children: [
//             // =================== SUMMARY CARD ===================
//             AnimatedSize(
//               duration: Duration(milliseconds: 300),
//               curve: Curves.easeOut,
//               child: AnimatedSwitcher(
//                 duration: Duration(milliseconds: 300),
//                 transitionBuilder: (child, animation) {
//                   return FadeTransition(
//                     opacity: animation,
//                     child: SlideTransition(
//                       position: Tween<Offset>(
//                         begin: Offset(0, -0.1),
//                         end: Offset.zero,
//                       ).animate(animation),
//                       child: child,
//                     ),
//                   );
//                 },
//                 child: Card(
//                   key: ValueKey("summary"),
//                   child: Padding(
//                     padding: EdgeInsets.all(12),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: _summaryBox(
//                             "Konsumsi",
//                             "2",
//                             Colors.deepOrange,
//                             Icons.local_dining,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             SizedBox(height: 10),

//             // ==================== LIST PENJUALAN ====================
//             Expanded(
//               child: Consumer<Penjualans>(
//                 builder: (context, value, child) {
//                   if (value.datas.isEmpty) {
//                     return Center(
//                       child: Text(
//                         "Belum ada data Konsumsi",
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     );
//                   }

//                   return ListView.builder(
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     itemCount: 4,
//                     itemBuilder: (context, index) {
//                       if (index != 3) {
//                         final p = value.datas[index];
//                         return Card(
//                           elevation: 3,
//                           color: Colors.deepOrange[50],
//                           margin: EdgeInsets.only(bottom: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 14,
//                               vertical: 10,
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // Nama menu + total jual
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         formatTimeOfDay(p.jam!),
//                                         style: TextStyle(
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                     Text(
//                                       "Rp ${p.total_harga}",
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.deepOrange,
//                                       ),
//                                     ),
//                                   ],
//                                 ),

//                                 SizedBox(height: 6),

//                                 // Jumlah terjual + tanggal
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Icon(
//                                           Icons.shopping_bag,
//                                           size: 14,
//                                           color: Colors.grey,
//                                         ),
//                                         SizedBox(width: 6),
//                                         Text(
//                                           " Porsi",
//                                           style: TextStyle(
//                                             fontSize: 11,
//                                             color: Colors.grey[700],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     Row(
//                                       children: [
//                                         Icon(
//                                           Icons.calendar_today,
//                                           size: 13,
//                                           color: Colors.grey,
//                                         ),
//                                         SizedBox(width: 6),
//                                         Text(
//                                           p.total_harga.toString(),
//                                           style: TextStyle(
//                                             fontSize: 11,
//                                             color: Colors.grey[700],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       }
//                       return InkWell(
//                         onTap: () {},
//                         child: Card(
//                           elevation: 3,
//                           color: Colors.deepOrange[100],
//                           margin: EdgeInsets.only(bottom: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Padding(
//                             padding: EdgeInsetsGeometry.symmetric(vertical: 16),
//                             child: Icon(Icons.add_circle),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // =================== SUMMARY BOX ===================
//   Widget _summaryBox(String label, String value, Color color, IconData icon) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.3), width: 1),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 14,
//               color: color,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 14,
//               color: color,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
