library private_teaching_tracker.global_variables;

import 'package:private_teaching_tracker/database/database_shared.dart';
import 'package:private_teaching_tracker/database/studentsClass.dart';

//GV's mapped here will be updated for sharing data between pages easily
List allStudentsGV = [];
List<String> allStudentNames = [];
List allHistoryDataGV = [];

Future<void> updateStudentGlobalData() async {
  //all Student data mapped to Global Variable
  allStudentsGV = await UserDatabase.instance.getStudentsData();

  //Student Name data mapped to Global variable
  List<String> studentNames = ['All Students'];
  allStudentsGV.forEach((element) {
    Student x = element;
    studentNames.add(x.name);
  });
  //To prevent duplicates
  allStudentNames = studentNames.toSet().toList();
}

Future<void> updateHistoryGlobalData() async {
  //all history data mapped to Global Variable
  allHistoryDataGV = await UserDatabase.instance.getAllLessonsHistoryData();
}
