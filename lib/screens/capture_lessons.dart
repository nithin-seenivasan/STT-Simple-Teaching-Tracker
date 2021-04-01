import 'package:flutter/material.dart';
import 'package:private_teaching_tracker/common/globalVariables.dart';
import 'package:private_teaching_tracker/database/database_shared.dart';
import 'package:private_teaching_tracker/database/historyClass.dart';
import 'package:private_teaching_tracker/database/studentsClass.dart';

class CaptureLessons extends StatefulWidget {
  @override
  _CaptureLessonsState createState() => _CaptureLessonsState();
}

class _CaptureLessonsState extends State<CaptureLessons> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Alert dialog to confirm/cancel the onTap gesture of the cards
  showAlertDialog(BuildContext context, Student student) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () async {
        //Get current time and write to the LessonsHistory table
        int x = DateTime.now().millisecondsSinceEpoch;
        //Write the data to the table - lessonend time is dependant on the defined lesson length in student table
        final id = await UserDatabase.instance.insertLesson(LessonsHistory(
            student.name,
            student.lessontype,
            x,
            x + student.lessonlength * 60000));
        print('inserted row id: $id');

        //Update GV with the history data
        await updateHistoryGlobalData();

        //Push to home, see the entered data immediately
        Navigator.pushReplacementNamed(context, 'home');
      },
    );

    Widget cancelButton = TextButton(
      child: Text("CANCEL"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Start Lesson Record?"),
      content: Text(
          "Confirm lesson start for ${student.name}, for ${student.lessontype}, for a duration of ${student.lessonlength} minutes?"),
      actions: [
        okButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //Returns the card which shows the student data
  Widget showData(Student student) {
    return GestureDetector(
      onTap: () {
        showAlertDialog(context, student);
      },
      child: Container(
          child: Card(
              color: Colors.white12,
              elevation: 2,
              child: ListTile(
                dense: false,
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: Text(
                    student.name,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: Text(
                    student.lessontype,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: Text(student.lessonlength.toString() + " minutes"),
                ),
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List allStudents = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Tap to Capture Lesson"),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Container(
            child: Expanded(
              child: Scrollbar(
                child: ListView.separated(
                  itemBuilder: (context, index) => showData(allStudents[index]),
                  itemCount: allStudents.length,
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.white24,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
