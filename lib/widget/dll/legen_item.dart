import 'package:flutter/material.dart';

Widget legendItem(Color color, String text) {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}
