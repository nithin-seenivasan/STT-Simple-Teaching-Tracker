import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  @override
  void initState() {
    super.initState();
    dynamicSelectedData(_selectedStudent);
  }

  @override
  void dispose() {
    super.dispose();
  }

  //To change the content of the cards depending on the dropdownbox element selected
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

  Widget showData(LessonsHistory history) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(history.starttime);
    var dateString = DateFormat.yMEd().add_jms().format(date);

    return GestureDetector(
      onTap: () {
        ///Edit individual elements here
      },
      child: Container(
          child: Card(
              color: Colors.white10,
              elevation: 5,
              child: ListTile(
                dense: true,
                subtitle: Text(
                  history.lessontype,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                title: Text(
                  history.name,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                trailing: Text(
                  dateString,
                  style: TextStyle(
                    fontSize: 15,
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
              child: DropdownButton<String>(
                iconSize: 40,
                iconEnabledColor: Colors.blue,
                value: _selectedStudent,
                onChanged: (newValue) {
                  setState(() {
                    _selectedStudent = newValue;
                    dynamicSelectedData(_selectedStudent);
                  });
                },
                items: allStudentNames.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(value)),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              flex: 9,
              child: Row(
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
