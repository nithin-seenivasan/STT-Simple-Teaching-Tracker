library private_teaching_tracker.global_variables;

import 'package:private_teaching_tracker/database/database_shared.dart';
import 'package:private_teaching_tracker/database/historyClass.dart';
import 'package:private_teaching_tracker/database/studentsClass.dart';

//GV's mapped here will be updated for sharing data between pages easily
List allStudentsGV = [];
List<String> allCurrentStudentNamesGV = [];
List<String> allHistoryStudentNamesGV = [];
List allHistoryDataGV = [];
List<String> allLessonTypesGV = [];

Future<void> updateStudentGlobalData() async {
  //all Student data mapped to Global Variable
  allStudentsGV = await UserDatabase.instance.getStudentsData();

  //CURRENT Student Name and Lesson Type data mapped to Global variable
  List<String> studentNames = ['All Students'];
  List<String> lessonTypes = ['All Lesson Types'];
  allStudentsGV.forEach((element) {
    Student x = element;
    studentNames.add(x.name);
    lessonTypes.add(x.lessontype);
  });
  //To prevent duplicates
  allCurrentStudentNamesGV = studentNames.toSet().toList();
  allLessonTypesGV = lessonTypes.toSet().toList();
}

Future<void> updateHistoryGlobalData() async {
  //all history data mapped to Global Variable
  allHistoryDataGV = await UserDatabase.instance.getAllLessonsHistoryData();

  //HISTORICAL Student Name data mapped to Global variable
  List<String> studentNames = ['All Students'];

  allHistoryDataGV.forEach((element) {
    LessonsHistory x = element;
    studentNames.add(x.name);
  });
  //To prevent duplicates
  allHistoryStudentNamesGV = studentNames.toSet().toList();
}
