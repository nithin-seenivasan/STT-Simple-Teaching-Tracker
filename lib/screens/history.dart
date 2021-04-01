import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:private_teaching_tracker/common/globalFunctions.dart';
import 'package:private_teaching_tracker/common/globalVariables.dart';
import 'package:private_teaching_tracker/database/database_shared.dart';
import 'package:private_teaching_tracker/database/historyClass.dart';

class TeachingHistory extends StatefulWidget {
  @override
  _TeachingHistoryState createState() => _TeachingHistoryState();
}

class _TeachingHistoryState extends State<TeachingHistory> {
  String _selectedStudent = "All Students";
  List selectedLessonsHistory = [];
  final TextEditingController startDateCtl = TextEditingController();
  final TextEditingController startTimeCtl = TextEditingController();
  final TextEditingController endDateCtl = TextEditingController();
  final TextEditingController endTimeCtl = TextEditingController();
  final TextEditingController lessonTypeCtl = TextEditingController();
  final dateError = SnackBar(
    content: Text('Invalid Date'),
    backgroundColor: Colors.red,
  );
  String newLessonType = "";

  @override
  void initState() {
    super.initState();
    dynamicSelectedData(_selectedStudent);
  }

  @override
  void dispose() {
    super.dispose();
    startTimeCtl.dispose();
    startDateCtl.dispose();
    endTimeCtl.dispose();
    endDateCtl.dispose();
  }

  //DropDownBox selection -> correct query for listview
  Future<void> dynamicSelectedData(String selectedStudent) async {
    if (selectedStudent == "All Students") {
      selectedLessonsHistory =
          await UserDatabase.instance.getAllLessonsHistoryData();
      setState(() {
        var x = selectedLessonsHistory.length;
        print(x);
      });
    } else {
      selectedLessonsHistory = await UserDatabase.instance
          .getSelectedLessonsHistoryData(selectedStudent);
      setState(() {
        var x = selectedLessonsHistory.length;
        print(x);
      });
    }
  }

  //Handles the entire editing logic, with the AlertDIalog as UI. Called -> onTap of Card.
  Future<void> _editHistoryDataDialog(
      BuildContext context, LessonsHistory history) async {
    startTimeCtl.text = parseHistoryTime(history.starttime);
    startDateCtl.text = parseHistoryDate(history.starttime);
    endDateCtl.text = parseHistoryDate(history.finishtime);
    endTimeCtl.text = parseHistoryTime(history.finishtime);
    lessonTypeCtl.text = history.lessontype;
    newLessonType = history.lessontype;

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    GlobalKey<AutoCompleteTextFieldState<String>> keyLessonType = GlobalKey();

    return showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(
              'Edit History Data',
              textAlign: TextAlign.center,
            ),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Type"),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: AutoCompleteTextField<String>(
                              controller: lessonTypeCtl,
                              key: keyLessonType,
                              clearOnSubmit: false,
                              suggestions: allLessonTypesGV,
                              decoration: textInputDecoration(),
                              itemFilter: (item, query) {
                                return item
                                    .toLowerCase()
                                    .startsWith(query.toLowerCase());
                              },
                              itemSorter: (a, b) {
                                return a.compareTo(b);
                              },
                              textSubmitted: (item) {
                                setState(() {
                                  print(item);
                                  newLessonType = item;
                                });
                              },
                              itemSubmitted: (item) {
                                setState(() {
                                  print(item);
                                  newLessonType = item;
                                });
                              },
                              textChanged: (item) {
                                setState(() {
                                  print(item);
                                  newLessonType = item;
                                });
                              },
                              itemBuilder: (context, item) {
                                // ui for the autocomplete row
                                return row(item);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Lesson Start ",
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Time: "),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: TextFormField(
                                  controller: startTimeCtl,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    var time = await showTimePicker(
                                      initialTime: TimeOfDay.fromDateTime(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              history.starttime)),
                                      context: context,
                                    );
                                    startTimeCtl.text = time.format(context);
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Cannot be empty";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    startTimeCtl.text = value;
                                  },
                                  decoration: textInputDecoration(),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Date: "),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: TextFormField(
                                  controller: startDateCtl,
                                  onTap: () async {
                                    DateTime date = DateTime(1900);
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    date = await showDatePicker(
                                        context: context,
                                        initialDate:
                                            DateTime.fromMillisecondsSinceEpoch(
                                                history.starttime),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100));
                                    try {
                                      setState(() {
                                        startDateCtl.text =
                                            "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}";
                                      });
                                    } catch (e) {
                                      startDateCtl.text = "";
                                    }
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Cannot be empty";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    startDateCtl.text = value;
                                  },
                                  decoration: textInputDecoration(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Lesson End "),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Time: "),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: TextFormField(
                                  controller: endTimeCtl,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    var time = await showTimePicker(
                                      initialTime: TimeOfDay.fromDateTime(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              history.finishtime)),
                                      context: context,
                                    );
                                    endTimeCtl.text = time.format(context);
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Cannot be empty";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    endTimeCtl.text = value;
                                  },
                                  //controller: _startTimeController,
                                  decoration: textInputDecoration(),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Date: "),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: TextFormField(
                                  controller: endDateCtl,
                                  onTap: () async {
                                    DateTime date = DateTime(1900);
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    date = await showDatePicker(
                                        context: context,
                                        initialDate:
                                            DateTime.fromMillisecondsSinceEpoch(
                                                history.finishtime),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100));
                                    try {
                                      setState(() {
                                        endDateCtl.text =
                                            "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}";
                                      });
                                    } catch (e) {
                                      endDateCtl.text = "";
                                    }
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Cannot be empty";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    endDateCtl.text = value;
                                  },
                                  decoration: textInputDecoration(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('DELETE'),
                onPressed: () async {
                  await UserDatabase.instance.deleteLesson(history);
                  Navigator.pushReplacementNamed(context, 'home');
                },
              ),
              TextButton(
                child: Text('SAVE'),
                onPressed: () async {
                  try {
                    String lessonStartDateTime =
                        startDateCtl.text + " " + startTimeCtl.text;
                    String lessonEndDateTime =
                        endDateCtl.text + " " + endTimeCtl.text;
                    var dateTimeObjStart = DateFormat('dd/MM/yy HH:mm')
                        .parse(lessonStartDateTime)
                        .millisecondsSinceEpoch;
                    var dateTimeObjEnd = DateFormat('dd/MM/yy HH:mm')
                        .parse(lessonEndDateTime)
                        .millisecondsSinceEpoch;

                    if (_formKey.currentState.validate() &&
                        dateTimeObjStart < dateTimeObjEnd &&
                        lessonStartDateTime != "") {
                      _formKey.currentState.save();
                      LessonsHistory modifiedHistory = LessonsHistory(
                          history.name,
                          newLessonType,
                          dateTimeObjStart,
                          dateTimeObjEnd);
                      await UserDatabase.instance
                          .updateLesson(history, modifiedHistory);
                      Navigator.pushReplacementNamed(context, 'home');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(dateError);
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(dateError);
                  }
                },
              ),
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  //Displays the selected data
  Widget showData(LessonsHistory history) {
    String dateString = parseDate(history.starttime);
    var lessonLength =
        ((history.finishtime - history.starttime) / 60000).round();
    //This is the card that each element is composed of
    return GestureDetector(
      onTap: () {
        _editHistoryDataDialog(context, history);
      },
      child: Container(
          child: Card(
              color: Color.fromRGBO(66, 66, 66, 0.5),
              elevation: 1,
              child: ListTile(
                dense: false,
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 8),
                  child: Text(
                    history.lessontype +
                        "\n" +
                        lessonLength.toString() +
                        " min",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    history.name,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 4, 0),
                  child: Text(
                    dateString,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
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
                      //dropdownColor: Colors.white12,
                      iconSize: 40,
                      iconEnabledColor: Colors.blue,
                      value: _selectedStudent,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedStudent = newValue;
                          dynamicSelectedData(_selectedStudent);
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
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              flex: 8,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Scrollbar(
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) =>
                            showData(selectedLessonsHistory[index]),
                        itemCount: selectedLessonsHistory.length,
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Colors.white24,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
