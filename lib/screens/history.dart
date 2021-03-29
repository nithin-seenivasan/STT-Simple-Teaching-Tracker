import 'package:flutter/material.dart';

class TeachingHistory extends StatefulWidget {
  @override
  _TeachingHistoryState createState() => _TeachingHistoryState();
}

class _TeachingHistoryState extends State<TeachingHistory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("This is the History Page"),
      ),
    );
  }
}
