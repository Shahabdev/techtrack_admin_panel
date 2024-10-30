import 'package:flutter/material.dart';

class TableHeaderText extends StatefulWidget {
  final String text;
  const TableHeaderText({required this.text});

  @override
  State<TableHeaderText> createState() => _TableHeaderTextState();
}

class _TableHeaderTextState extends State<TableHeaderText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: const TextStyle(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}
