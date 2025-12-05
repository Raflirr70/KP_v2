// import 'package:flutter/material.dart';
// import 'package:kerprak/model/cabang.dart';
// import 'package:kerprak/model/penjadwalan.dart';
// import 'package:kerprak/model/user.dart';
// import 'package:kerprak/widget/menu/dashboard_admin_menu.dart';
// import 'package:provider/provider.dart';

// class PenjadwalanPage extends StatefulWidget {
//   const PenjadwalanPage({super.key});

//   @override
//   State<PenjadwalanPage> createState() => _PenjadwalanPageState();
// }

// class _PenjadwalanPageState extends State<PenjadwalanPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => DashboardAdminMenu()),
//             );
//           },
//           icon: Icon(Icons.arrow_back_ios_new_sharp),
//         ),
//         title: Text("Penjadwalan Karyawan"),
//         centerTitle: true,
//       ),
//       body: Consumer3<Penjadwalans, Cabangs, Users>(
//         builder: (context, jadwal, cabang, user, child) {
//           return Expanded(
//             child: ListView.builder(
//               itemCount: cabang.datas.length,
//               itemBuilder: (context, index) {
//                 return Card(
//                   child: InkWell(
//                     child: Column(
//                       // mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           cabang.datas[index].nama,
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Container(
//                           padding: EdgeInsets.all(10),
//                           width: double.infinity,
//                           child: Column(
//                             children: user.datas.map<Widget>((e) {
//                               return Card(
//                                 color: Colors.amber[200],
//                                 margin: EdgeInsets.symmetric(vertical: 4),
//                                 child: ListTile(
//                                   title: Text(
//                                     e.nama,
//                                     style: TextStyle(fontSize: 16),
//                                   ),
//                                   trailing: InkWell(
//                                     borderRadius: BorderRadius.circular(30),
//                                     onTap: () {
//                                       showDialog(
//                                         context: context,
//                                         builder: (context) {
//                                           return AlertDialog(
//                                             title: Text(
//                                               "Hapus karyawan ini?",
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             content: Text(
//                                               "Tindakan ini tidak dapat dibatalkan.",
//                                             ),
//                                             actions: [
//                                               TextButton(
//                                                 onPressed: () =>
//                                                     Navigator.pop(context),
//                                                 child: Text("Batal"),
//                                               ),
//                                               ElevatedButton(
//                                                 style: ElevatedButton.styleFrom(
//                                                   backgroundColor: Colors.red,
//                                                 ),
//                                                 onPressed: () {
//                                                   // aksi hapus nanti
//                                                   Navigator.pop(context);
//                                                 },
//                                                 child: Text("Hapus"),
//                                               ),
//                                             ],
//                                           );
//                                         },
//                                       );
//                                     },
//                                     child: Container(
//                                       padding: EdgeInsets.all(10),
//                                       decoration: BoxDecoration(
//                                         color: Colors.red.withOpacity(0.15),
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: Icon(
//                                         Icons.close,
//                                         color: Colors.red,
//                                         size: 20,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                         ListTile(
//                           leading: Icon(Icons.add, color: Colors.black),
//                           title: Text("Tambah Karyawan"),
//                           onTap: () {
//                             showDialog(
//                               context: context,
//                               builder: (context) {
//                                 String? selectedValue;
//                                 var dataKaryawan = user.datas;

//                                 return AlertDialog(
//                                   title: Text("Pilih Karyawan"),

//                                   content: StatefulBuilder(
//                                     builder: (context, setState) {
//                                       return SingleChildScrollView(
//                                         child: Column(
//                                           children: [
//                                             DropdownButtonFormField<String>(
//                                               decoration: InputDecoration(
//                                                 labelText: "Pilih Karyawan",
//                                               ),
//                                               value: selectedValue,
//                                               items: dataKaryawan
//                                                   .map<
//                                                     DropdownMenuItem<String>
//                                                   >((nama) {
//                                                     return DropdownMenuItem(
//                                                       value: nama.nama,
//                                                       child: Text(nama.nama),
//                                                     );
//                                                   })
//                                                   .toList(),
//                                               onChanged: (val) {
//                                                 setState(
//                                                   () => selectedValue = val,
//                                                 );
//                                               },
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () => Navigator.pop(context),
//                                       child: Text("Batal"),
//                                     ),
//                                     ElevatedButton(
//                                       onPressed: () {
//                                         Navigator.pop(context);
//                                         print("Dipilih: $selectedValue");
//                                       },
//                                       child: Text("Simpan"),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                     onTap: () {},
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
