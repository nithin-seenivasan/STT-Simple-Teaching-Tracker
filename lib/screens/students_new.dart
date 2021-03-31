import 'package:flutter/material.dart';
import 'package:private_teaching_tracker/common/globalVariables.dart';
import 'package:private_teaching_tracker/common/isNumeric.dart';
import 'package:private_teaching_tracker/database/database_shared.dart';
import 'package:private_teaching_tracker/database/studentsClass.dart';

class NewStudent extends StatefulWidget {
  @override
  _NewStudentState createState() => _NewStudentState();
}

class _NewStudentState extends State<NewStudent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //modularize the decoration to prevent repetitive code
  InputDecoration textInputDecoration() {
    return InputDecoration(
        errorStyle: TextStyle(height: 0),
        isDense: true, // Added this
        contentPadding: EdgeInsets.all(8),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.green)),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue)),
        errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red)),
        border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.green)),
        errorMaxLines: 1);
  }

  //Show the alert dialog once the new student data has been entered
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        //Redirect to home
        Navigator.pushReplacementNamed(context, 'home');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Successful"),
      content: Text(
          "The new student has been successfully saved. \n\nThe 'Capture Lesson' can now be used to record the lesson for this student"),
      actions: [
        okButton,
      ],
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String newStudentName = "";
  String lessonType = "";
  int lessonLength = 0;

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
      body: Padding(
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
                      "New Student Record",
                      textScaleFactor: 1.3,
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
                          Text("Name of Student: "),
                          Spacer(
                            flex: 1,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextFormField(
                              autocorrect: false,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Cannot be empty";
                                }
                                return null;
                              },
                              decoration: textInputDecoration(),
                              onSaved: (t) {
                                newStudentName = t;
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
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextFormField(
                              autocorrect: false,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                              decoration: textInputDecoration(),
                              onSaved: (s) {
                                lessonType = s;
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
                              Text("Lesson Length: "),
                              Spacer(
                                flex: 1,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
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
                                    lessonLength = int.parse(f);
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
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            FocusManager.instance.primaryFocus.unfocus();
                            if (_formKey.currentState.validate()) {
                              //Save the formKey -> All the onSave functions are triggered
                              _formKey.currentState.save();
                              await processNewStudent();
                              showAlertDialog(context);
                            } else {
                              FocusManager.instance.primaryFocus.unfocus();
                              print("Some items in-valid");
                            }
                          },
                          child: Text("Next"),
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
    );
  }
}
