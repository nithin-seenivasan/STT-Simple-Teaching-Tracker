import 'package:flutter/material.dart';
import 'package:private_teaching_tracker/common/globalFunctions.dart';
import 'package:private_teaching_tracker/common/globalVariables.dart';
import 'package:private_teaching_tracker/common/isNumeric.dart';
import 'package:private_teaching_tracker/database/database_shared.dart';
import 'package:private_teaching_tracker/database/studentsClass.dart';

class AllStudents extends StatefulWidget {
  @override
  _AllStudentsState createState() => _AllStudentsState();
}

class _AllStudentsState extends State<AllStudents> {
  String _selectedLessonType = "All Lesson Types";
  List selectedLessonsType = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lessonTypeController = TextEditingController();
  TextEditingController _lessonLengthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    updateStudentGlobalData();
    dynamicSelectedData(_selectedLessonType);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _lessonTypeController.dispose();
    _lessonLengthController.dispose();
  }

  //To change the content of the cards depending on the dropdownbox element selected
  Future<void> dynamicSelectedData(String selectedLessonType) async {
    if (selectedLessonType == "All Lesson Types") {
      selectedLessonsType = await UserDatabase.instance.getStudentsData();
      setState(() {
        var x = selectedLessonsType.length;
        print(x);
      });
    } else {
      selectedLessonsType = await UserDatabase.instance
          .getSelectedStudentsData(selectedLessonType);
      setState(() {
        var x = selectedLessonsType.length;
        print(x);
      });
    }
  }

  //Handles the entire editing logic, with the AlertDIalog as UI. Called -> onTap of Card.
  Future<void> _editStudentDataDialog(
      BuildContext context, Student student) async {
    _nameController.text = student.name;
    _lessonTypeController.text = student.lessontype;
    _lessonLengthController.text = student.lessonlength.toString();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Student Data'),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Name: "),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Cannot be empty";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _nameController.text = value;
                                print(_nameController.text);
                              },
                              controller: _nameController,
                              decoration: textInputDecoration(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Lesson\nType: "),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Cannot be empty";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  _lessonTypeController.text = value;
                                  print(value);
                                });
                              },
                              controller: _lessonTypeController,
                              decoration: textInputDecoration(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Lesson\nLength\n(min): "),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
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
                              onSaved: (value) {
                                setState(() {
                                  _lessonLengthController.text = value;
                                  print(value);
                                });
                              },
                              controller: _lessonLengthController,
                              decoration: textInputDecoration(),
                            ),
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
                  await UserDatabase.instance.deleteStudent(student);
                  Navigator.pushReplacementNamed(context, 'allStudents');
                },
              ),
              TextButton(
                child: Text('SAVE'),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    var _temp;
                    try {
                      _temp = int.parse(_lessonLengthController.text);
                    } catch (e) {
                      _temp = 0;
                    }
                    _formKey.currentState.save();
                    Student modifiedStudent = Student(_nameController.text,
                        _lessonTypeController.text, _temp);
                    await UserDatabase.instance
                        .updateStudent(student, modifiedStudent);
                    Navigator.pushReplacementNamed(context, 'allStudents');
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

  //Returns the card which shows the student data
  Widget showData(Student student) {
    return GestureDetector(
      onTap: () {
        _editStudentDataDialog(context, student);
      },
      child: Container(
          child: Card(
              color: Color.fromRGBO(66, 66, 66, 0.5),
              elevation: 1,
              borderOnForeground: false,
              child: ListTile(
                dense: true,
                title: Text(
                  student.name,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  "Lesson Type: " + student.lessontype,
                  style: TextStyle(fontSize: 15),
                ),
                trailing:
                    // Spacer(
                    //   flex: 5,
                    // ),
                    Text(student.lessonlength.toString() + " minutes"),
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tap to edit Student Data"),
        centerTitle: true,
      ),
      body: Container(
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
                    DropdownButton<String>(
                      iconSize: 40,
                      iconEnabledColor: Colors.blue,
                      value: _selectedLessonType,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedLessonType = newValue;
                          dynamicSelectedData(_selectedLessonType);
                        });
                      },
                      items: allLessonTypesGV.map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(value)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                flex: 9,
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
                              showData(selectedLessonsType[index]),
                          itemCount: selectedLessonsType.length,
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
      ),
    );
  }
}
