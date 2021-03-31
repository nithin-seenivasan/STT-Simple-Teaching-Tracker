import 'package:flutter/material.dart';
import 'package:private_teaching_tracker/common/globalVariables.dart';
import 'package:private_teaching_tracker/database/database_shared.dart';

class StudentsLandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("This is the Students Landing Page"),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'newStudent');
              },
              child: Text("New Student"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'allStudents');
              },
              child: Text("All Students"),
            ),
            ElevatedButton(
              child: Text(
                'query all students',
              ),
              onPressed: () {
                _queryStudent();
              },
            ),
            ElevatedButton(
              child: Text(
                'query history',
              ),
              onPressed: () {
                _queryLessons();
              },
            ),
            ElevatedButton(
              child: Text(
                'print GV Students',
              ),
              onPressed: () {
                print(allStudentsGV);
              },
            ),
            ElevatedButton(
              child: Text(
                'print GV Names',
              ),
              onPressed: () {
                print(allStudentNames);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Button onPressed methods
  void _queryStudent() async {
    List allStudents = await UserDatabase.instance.getStudentsData();
    print(allStudents);
  }

  void _queryLessons() async {
    List allLessonsHistory =
        await UserDatabase.instance.getAllLessonsHistoryData();
    print(allLessonsHistory);
  }

  // void _query() async {
  //   final allRows = await dbHelper.queryAllRows();
  //   print('query all rows:');
  //   allRows.forEach((row) => print(row));
  // }
  //
  // void _update() async {
  //   // row to update
  //   Map<String, dynamic> row = {
  //     DatabaseHelper.columnId: 1,
  //     DatabaseHelper.columnName: 'Mark',
  //     DatabaseHelper.columnAge: 28
  //   };
  //   final rowsAffected = await dbHelper.update(row);
  //   print('updated $rowsAffected row(s)');
  // }
  //
  // void _delete() async {
  //   // Assuming that the number of rows is the id for the last row.
  //   final id = await dbHelper.queryRowCount();
  //   final rowsDeleted = await dbHelper.delete(id);
  //   print('deleted $rowsDeleted row(s): row $id');
  // }
}
