import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import 'globalVariables.dart';

const _darkColor = PdfColor.fromInt(0xff242424);
const PdfColor baseColor = PdfColor.fromInt(0xff242424);
const PdfColor _baseTextColor = PdfColor.fromInt(0xffffffff);

///NOTE: Code below is adapted from https://devbybit.com/flutter-generating-pdfs-in-flutter/ (credit where due!)
//create pdf file + its theme data here
Future<bool> generatePDF(List<String> columns, List<List<String>> tableData,
    List<String> headerData) async {
  Widget headerWidget = pdfHeader(headerData);
  //initialize PDF file
  final Document pdf = Document();
  //Add pages
  pdf.addPage(MultiPage(
      crossAxisAlignment: CrossAxisAlignment.start,
      build: (Context context) => <Widget>[
            Header(
              level: 0,
              child: Center(child: headerWidget),
            ),
            Table.fromTextArray(
              context: context,
              border: null,
              headerAlignment: Alignment.centerLeft,
              cellAlignment: Alignment.centerLeft,
              headerDecoration: BoxDecoration(
                color: baseColor,
              ),
              headerHeight: 25,
              cellHeight: 30,
              headerStyle: TextStyle(
                color: _baseTextColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              cellStyle: const TextStyle(
                color: _darkColor,
                fontSize: 10,
              ),
              headers: List<String>.generate(
                columns.length,
                (col) {
                  return columns[col];
                },
              ),
              data: List<List<String>>.generate(
                tableData.length,
                (row) => List<String>.generate(
                  columns.length,
                  (col) {
                    return tableData[row][col];
                  },
                ),
              ),
            ),
          ]));

  //Save the file to the path
  try {
    Directory dir = await getExternalStorageDirectory();

    ///ToDo: How does this work on iOS?
    print(dir);
    String filePath = dir.path + "/STT/";
    //Write to GV to access it from Reports page
    fileNameGV = "${headerData[0]}_${headerData[3]}.pdf";
    print(fileNameGV);
    filePathGV = filePath + fileNameGV;
    print(filePathGV);
    //Check if Filepath exists - create if not
    // ignore: unrelated_type_equality_checks
    if (Directory(filePath).exists() != true) {
      new Directory(filePath).createSync(recursive: true);
      final File file = File(filePathGV);
      file.writeAsBytesSync(await pdf.save());
      return true;
    } else {
      final File file = File(filePathGV);
      file.writeAsBytesSync(await pdf.save());
      return true;
    }
  } catch (e) {
    return false;
  }
}

//pdf header body
Widget pdfHeader(List<String> headerData) {
  return Container(
      margin: const EdgeInsets.only(bottom: 8, top: 8),
      padding: const EdgeInsets.fromLTRB(10, 7, 10, 4),
      child: Column(children: [
        Text(
          headerData[0], //Student Name
          style: TextStyle(
              fontSize: 16, color: _darkColor, fontWeight: FontWeight.bold),
        ),
        Text(headerData[1],
            style: TextStyle(fontSize: 14, color: _darkColor)), //Lesson Type
        Text(headerData[2],
            style: TextStyle(fontSize: 14, color: _darkColor)), // Date Stamp
      ]));
}
