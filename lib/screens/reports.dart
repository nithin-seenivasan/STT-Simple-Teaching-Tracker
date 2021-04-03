import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:private_teaching_tracker/common/generatePDF.dart';
import 'package:private_teaching_tracker/common/globalFunctions.dart';
import 'package:private_teaching_tracker/common/globalVariables.dart';
import 'package:private_teaching_tracker/database/database_shared.dart';
import 'package:private_teaching_tracker/database/historyClass.dart';

class SelectStudentForReport extends StatefulWidget {
  @override
  _SelectStudentForReportState createState() => _SelectStudentForReportState();
}

class _SelectStudentForReportState extends State<SelectStudentForReport> {
  String _selectedStudent = "All Students";
  List selectedLessonsHistory = [];

  //Step 1: Select student
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                  child: Text(
                    "Filter:",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: DropdownButton<String>(
                    iconSize: 40,
                    iconEnabledColor: Colors.blue,
                    value: _selectedStudent,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedStudent = newValue;
                      });
                    },
                    items: allHistoryStudentNamesGV.map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.55,
                            child: Text(value)),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            _selectedStudent != "All Students"
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FilterLessonType(_selectedStudent)));
                    },
                    child: Text("SUBMIT"))
                : Text("Select a student"),
          ],
        ),
      ),
    );
  }
}

//Step 2: Select lesson type + select Month for that student (in case 1 student, 2 lesson types)
class FilterLessonType extends StatefulWidget {
  final String studentName;
  FilterLessonType(this.studentName);
  @override
  _FilterLessonTypeState createState() => _FilterLessonTypeState();
}

class _FilterLessonTypeState extends State<FilterLessonType> {
  //Initialize variables
  List selectedLessonsHistory = [];
  List<String> lessonTypesPerStudent = ["Select Lesson"];
  String _selectedLessonType = "Select Lesson";
  List<String> historyTimePeriodPerSTudent = ["Select Month"];
  String _selectedMonth = "Select Month";

  @override
  void initState() {
    super.initState();
    filterLessonTypeFromStudentName(widget.studentName);
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Get the necessary data to populate the dropdown boxes
  void filterLessonTypeFromStudentName(String selectedStudent) async {
    //Query LessonsHistory to get the history for the selected student
    selectedLessonsHistory = await UserDatabase.instance
        .getSelectedLessonsHistoryData(selectedStudent);
    //For each element, grab the necessary data
    selectedLessonsHistory.forEach((element) {
      LessonsHistory x = element;
      lessonTypesPerStudent.add(x.lessontype);
      historyTimePeriodPerSTudent.add(parseHistoryMonthYear(x.starttime));
    });
    //Prevent duplicates by converting to set and back to list
    lessonTypesPerStudent = lessonTypesPerStudent.toSet().toList();
    historyTimePeriodPerSTudent = historyTimePeriodPerSTudent.toSet().toList();
    setState(() {
      var x = selectedLessonsHistory.length;
      print(x);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter Lesson Type"),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "Selected Student:  ${widget.studentName}",
                    style: TextStyle(fontSize: 22),
                  )),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                    child: Text(
                      "Filter:",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: DropdownButton<String>(
                      iconSize: 40,
                      iconEnabledColor: Colors.blue,
                      value: _selectedLessonType,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedLessonType = newValue;
                        });
                      },
                      items: lessonTypesPerStudent.map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: Text(value)),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //Reactive UI - show only where required
              _selectedLessonType != "Select Lesson"
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                              child: Text(
                                "Filter:",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: DropdownButton<String>(
                                iconSize: 40,
                                iconEnabledColor: Colors.blue,
                                value: _selectedMonth,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedMonth = newValue;
                                  });
                                },
                                items: historyTimePeriodPerSTudent.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.55,
                                        child: Text(value)),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        _selectedMonth != "Select Month"
                            ? ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              GenerateSelectedDataReport(
                                                  widget.studentName,
                                                  _selectedLessonType,
                                                  _selectedMonth)));
                                },
                                child: Text("SUBMIT"))
                            : Text("Select a Month"),
                      ],
                    )
                  : Text("Select a Lesson Type"),
            ],
          ),
        ),
      ),
    );
  }
}

//Step 3: Generate reports based on the data selected in the previous 2 steps
class GenerateSelectedDataReport extends StatefulWidget {
  final String selectedStudentName;
  final String lessonType;
  final String selectedMonth;
  GenerateSelectedDataReport(
      this.selectedStudentName, this.lessonType, this.selectedMonth);

  @override
  _GenerateSelectedDataReportState createState() =>
      _GenerateSelectedDataReportState();
}

class _GenerateSelectedDataReportState
    extends State<GenerateSelectedDataReport> {
  List allStudentHistory = [];
  List filteredStudentHistory = [];
  String monthYearFileName = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Called from StreamBuilder, so that data is always ready to display
  Future<String> queryForReportData(
      String studentName, String selectedMonth) async {
    //Query all historical data for student
    allStudentHistory =
        await UserDatabase.instance.getSelectedLessonsHistoryData(studentName);
    int i = 1;
    //Compare to each element of allStudentsHistory
    allStudentHistory.forEach((element) {
      LessonsHistory x = element;
      String compareMonthYear = parseHistoryMonthYear(x.starttime);
      //Compare the selected month with the historical record
      if (compareMonthYear == selectedMonth) {
        String compareLessonType = x.lessontype;
        //Compare selected lesson type with historical record
        if (compareLessonType == widget.lessonType) {
          monthYearFileName = parsePDFMonthYearFormat(x.starttime);
          String lessonDuration =
              ((x.finishtime - x.starttime) / 60000).round().toString();
          var y = {
            "S.No": i.toString(),
            "Date": parseDate(x.starttime),
            "Duration": "$lessonDuration"
          };
          filteredStudentHistory.add(y);
          print(filteredStudentHistory.length);
          i++;
        }
      }
    });
    print(filteredStudentHistory);
    return Future.value("Data loaded successfully");
  }

  //Generate data as List of List<Strings>, just like how the PDF package needs it
  List<List<String>> _generatePDFData() {
    List<List<String>> data = [];
    for (dynamic d in filteredStudentHistory)
      data.add(<String>[d['S.No'].toString(), d['Date'], d['Duration']]);
    return data;
  }

  //Define static snackbar
  final exportError = SnackBar(
    content: Text('Export Error'),
    backgroundColor: Colors.red,
  );

  //Define dynamic snackbar
  void showSuccessfulSnackBar(String fileName, String filePath) {
    final exportSuccess = SnackBar(
      duration: Duration(seconds: 10),
      content: Text(fileName + ' export successful'),
      backgroundColor: Colors.blue,
      action: SnackBarAction(
        label: 'Open',
        onPressed: () async {
          print("This is running?");
          print(filePath);
          await OpenFile.open(filePath);
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(exportSuccess);
  }

  //The data sent to the PDF generator is previewed here
  Widget previewBody() {
    return Container(
      child: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                    onPressed: () {
                      var columns = ["S.No", "Date", "Length (min)"];
                      //Header Data to personalize the PDF
                      List<String> headerData = [
                        widget.selectedStudentName,
                        widget.lessonType,
                        widget.selectedMonth,
                        monthYearFileName,
                      ];
                      generatePDF(columns, _generatePDFData(), headerData)
                          .then((value) {
                        if (value)
                          showSuccessfulSnackBar(fileNameGV, filePathGV);
                        else
                          ScaffoldMessenger.of(context)
                              .showSnackBar(exportError);
                      });
                    },
                    child: Text("EXPORT PDF")),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
                child: Text(
                  "${widget.selectedStudentName}",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  "${widget.lessonType}",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  "${widget.selectedMonth}",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    headingRowHeight: 50,
                    columnSpacing: 40,
                    dataRowHeight: 40,
                    sortAscending: true,
                    columns: tableColumns(),
                    rows: List.generate(
                      filteredStudentHistory.length,
                      (index) => _getDataRow(filteredStudentHistory[index]),
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }

  //Defines the Row identifiers for the Data Table
  DataRow _getDataRow(dynamic data) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(
          data['S.No'].toString(),
          style: TextStyle(fontSize: 14),
        )),
        DataCell(Text(
          data['Date'].toString(),
          style: TextStyle(fontSize: 14),
        )),
        DataCell(Text(
          data['Duration'].toString(),
          style: TextStyle(fontSize: 14),
        )),
      ],
    );
  }

  //function to populate table columns for the DataTable
  List<DataColumn> tableColumns() {
    return [
      DataColumn(
        label: Padding(
          padding: EdgeInsets.only(top: 3, bottom: 3),
          child: Text(
            "S.No",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ),
      DataColumn(
        label: Padding(
          padding: EdgeInsets.only(top: 3, bottom: 3),
          child: Text(
            "Date",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ),
      DataColumn(
        label: Padding(
          padding: EdgeInsets.only(top: 3, bottom: 3),
          child: Text(
            "Length\n(min)",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Preview and Export"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        //Wait until queryForReportData is completed - ensures that Widget is only built with updated data
        future: queryForReportData(
            widget.selectedStudentName, widget.selectedMonth),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          // AsyncSnapshot<Your object type>
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Please wait its loading...'));
          } else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else
              return previewBody();
          }
        },
      ),
    );
  }
}
