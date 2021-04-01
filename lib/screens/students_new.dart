import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:private_teaching_tracker/common/globalFunctions.dart';
import 'package:private_teaching_tracker/common/globalVariables.dart';
import 'package:private_teaching_tracker/common/isNumeric.dart';
import 'package:private_teaching_tracker/database/database_shared.dart';
import 'package:private_teaching_tracker/database/studentsClass.dart';

class NewStudent extends StatefulWidget {
  @override
  _NewStudentState createState() => _NewStudentState();
}

class _NewStudentState extends State<NewStudent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<AutoCompleteTextFieldState<String>> keyName = GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> keyLessonType = GlobalKey();
  String newStudentName = "";
  String lessonType = "";
  int lessonLength = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final inputError = SnackBar(
    content: Text('Check entry'),
    backgroundColor: Colors.red,
  );

  //Show the alert dialog once the new student data has been entered
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget homeButton = TextButton(
      child: Text("Home"),
      onPressed: () {
        //Redirect to home
        Navigator.pushReplacementNamed(context, 'home');
      },
    );

    Widget captureLessonButton = TextButton(
      child: Text("Capture Lesson"),
      onPressed: () {
        //Redirect to Capture Lesson
        Navigator.pushReplacementNamed(context, 'captureLessons',
            arguments: allStudentsGV);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Successful"),
      content: Text(
          "The new student has been successfully saved. \n\nThe 'Capture Lesson' can now be used to record the lesson for this student"),
      actions: [homeButton, captureLessonButton],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //Code to upload the student data to the database and update the global variables
  Future<bool> processNewStudent() async {
    final id = await UserDatabase.instance
        .insertStudent(Student(newStudentName, lessonType, lessonLength));
    print('inserted row id: $id');
    await updateStudentGlobalData();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Student"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Form(
              key: _formKey,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20.0),
                      child: Text(
                        "Record New Student",
                        textScaleFactor: 1.4,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Student Name: "),
                            Spacer(
                              flex: 1,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: AutoCompleteTextField<String>(
                                key: keyName,
                                clearOnSubmit: false,
                                suggestions: allHistoryStudentNamesGV,
                                decoration: textInputDecoration(),
                                itemFilter: (item, query) {
                                  return item
                                      .toLowerCase()
                                      .startsWith(query.toLowerCase());
                                },
                                itemSorter: (a, b) {
                                  return a.compareTo(b);
                                },
                                itemSubmitted: (item) {
                                  setState(() {
                                    print(item);
                                    newStudentName = item;
                                  });
                                },
                                textChanged: (item) {
                                  setState(() {
                                    print(item);
                                    newStudentName = item;
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Lesson Type: "),
                            Spacer(
                              flex: 1,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: AutoCompleteTextField<String>(
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
                                itemSubmitted: (item) {
                                  setState(() {
                                    print(item);
                                    lessonType = item;
                                  });
                                },
                                textChanged: (item) {
                                  setState(() {
                                    print(item);
                                    lessonType = item;
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: 40,
                        child: Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Lesson Length \n(minutes): "),
                                Spacer(
                                  flex: 1,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Cannot be empty";
                                      }

                                      final components = isNumeric(value);
                                      if (components == true) {
                                        return null;
                                      }
                                      return "Numbers only";
                                    },
                                    onSaved: (f) {
                                      try {
                                        lessonLength = int.parse(f);
                                      } catch (e) {
                                        lessonLength = 0;
                                      }
                                    },
                                    decoration: textInputDecoration(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: ElevatedButton(
                              onPressed: () async {
                                FocusManager.instance.primaryFocus.unfocus();
                                _formKey.currentState.save();
                                if (newStudentName != null &&
                                    lessonType != null &&
                                    lessonLength != 0) {
                                  //Save the formKey -> All the onSave functions are triggered
                                  await processNewStudent();
                                  showAlertDialog(context);
                                } else {
                                  FocusManager.instance.primaryFocus.unfocus();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(inputError);
                                  print("Some items in-valid");
                                }
                              },
                              child: Text("Next"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
