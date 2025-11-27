import 'package:flutter/material.dart';
import 'package:kerprak/widget/search/search_simple.dart';

class PengeluaranPage extends StatefulWidget {
  const PengeluaranPage({super.key});

  @override
  State<PengeluaranPage> createState() => _PengeluaranPageState();
}

class _PengeluaranPageState extends State<PengeluaranPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Halaman Pengeluaran"), centerTitle: true),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: Colors.black),
              ),
            ),
            child: Row(
              children: [Expanded(child: SearchSimple(data: []))],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 12 + 1,
              itemBuilder: (context, index) {
                if (index == 12) {
                  return InkWell(
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Text("data"),
                      ),
                    ),
                    onTap: () {},
                  );
                }
                return Card(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    width: double.infinity,
                    child: Row(
                      children: [
                        SizedBox(width: 150, child: Text("Nama Pengeluaran")),
                        SizedBox(width: 10, child: Text(":")),
                        Expanded(child: Text("Rp 123.000")),
                        SizedBox(width: 20),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.highlight_remove),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
