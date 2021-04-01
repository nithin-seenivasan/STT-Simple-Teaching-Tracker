import 'package:flutter/material.dart';

class StudentsLandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'newStudent');
                },
                child: Text("Add New Student"),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'allStudents');
                },
                child: Text("Edit Existing Students"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // // Button onPressed methods
  // void _queryStudent() async {
  //   List allStudents = await UserDatabase.instance.getStudentsData();
  //   print(allStudents);
  // }
  //
  // void _queryLessons() async {
  //   List allLessonsHistory =
  //       await UserDatabase.instance.getAllLessonsHistoryData();
  //   print(allLessonsHistory);
  // }

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
