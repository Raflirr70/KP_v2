import 'package:flutter/material.dart';
import 'package:kerprak/model/search.dart';
import 'package:provider/provider.dart';

class SearchSimple extends StatefulWidget {
  final List<String> data;

  const SearchSimple({super.key, required this.data});

  @override
  State<SearchSimple> createState() => _SearchSimpleState();
}

class _SearchSimpleState extends State<SearchSimple> {
  final TextEditingController _search = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  double w = 150;
  double h = 30;

  @override
  void initState() {
    super.initState();

    // set data awal ke provider sekali saja
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchProvider>().setData(widget.data);
    });

    _focusNode.addListener(() {
      setState(() {
        w = _focusNode.hasFocus || _search.text.isNotEmpty ? 250 : 150;
        h = _focusNode.hasFocus || _search.text.isNotEmpty ? 40 : 30;
      });
    });

    _search.addListener(() {
      context.read<SearchProvider>().search(_search.text);
    });
  }

  @override
  void dispose() {
    _search.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: w,
      height: h,
      child: TextField(
        controller: _search,
        focusNode: _focusNode,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          hintText: "Search",
          suffixIcon: _search.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _search.clear();
                    context.read<SearchProvider>().reset();
                    _focusNode.unfocus();
                    setState(() {});
                  },
                )
              : const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
