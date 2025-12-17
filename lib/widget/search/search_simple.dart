import 'package:flutter/material.dart';

class SearchSimple extends StatefulWidget {
  final TextEditingController controller;

  const SearchSimple({super.key, required this.controller});

  @override
  State<SearchSimple> createState() => _SearchSimpleState();
}

class _SearchSimpleState extends State<SearchSimple> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {}); // supaya tombol clear muncul/hilang
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 250,
      height: 40,
      child: TextField(
        controller: widget.controller,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          hintText: "Search",
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    widget.controller.clear();
                  },
                )
              : const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (_) {
          setState(() {}); // pastikan rebuild untuk tombol clear
        },
      ),
    );
  }
}
