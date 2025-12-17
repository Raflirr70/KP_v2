import 'package:flutter/material.dart';

Widget infoRow(IconData icon, String label, String value) {
  return Row(
    children: [
      Icon(icon, size: 18, color: Colors.grey[700]),
      SizedBox(width: 8),
      SizedBox(width: 80, child: Text(label)),
      Expanded(
        child: Text(
          ": $value",
          style: TextStyle(fontSize: 13, color: Colors.grey[800]),
        ),
      ),
    ],
  );
}
