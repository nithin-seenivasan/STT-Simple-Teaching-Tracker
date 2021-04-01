//modularize the decoration to prevent repetitive code
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

InputDecoration textInputDecoration() {
  return InputDecoration(
      errorStyle: TextStyle(height: 0),
      isDense: true, // Added this
      contentPadding: EdgeInsets.all(8),
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.green)),
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue)),
      errorBorder:
          const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.green)),
      errorMaxLines: 1);
}

//MSSE - MilliSecondsSinceEpoch to Date String
String parseDate(int inputMSTES) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(inputMSTES);
  String dateString = DateFormat("MMMM dd, yyyy\nEEEE, HH:mm").format(date);
  return dateString;
}

//Parse MSSE to output Date For the History edit function
String parseHistoryDate(int inputMSTES) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(inputMSTES);
  String dateString = DateFormat("dd/MM/yy").format(date);
  return dateString;
}

//Parse MSSE to output Time For the History edit function
String parseHistoryTime(int inputMSTES) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(inputMSTES);
  String timeString = DateFormat("HH:mm").format(date);
  return timeString;
}

//Row used to generate the autocomplete suggestions
Widget row(String item) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        item,
        style: TextStyle(fontSize: 16.0),
      ),
    ],
  );
}
