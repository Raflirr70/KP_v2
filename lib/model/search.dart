import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  List<String> _all = [];
  List<String> _filtered = [];

  List<String> get filtered => _filtered;

  // set data awal
  void setData(List<String> data) {
    _all = data;
    _filtered = List.from(data);
    notifyListeners();
  }

  // update hasil search
  void search(String q) {
    q = q.toLowerCase();
    _filtered = _all.where((e) => e.toLowerCase().contains(q)).toList();
    notifyListeners();
  }

  // clear
  void reset() {
    _filtered = List.from(_all);
    notifyListeners();
  }
}
