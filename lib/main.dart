import 'package:flutter/material.dart';
import 'package:private_teaching_tracker/screens/capture_lessons.dart';
import 'package:private_teaching_tracker/screens/history.dart';
import 'package:private_teaching_tracker/screens/reports.dart';
import 'package:private_teaching_tracker/screens/students_all.dart';
import 'package:private_teaching_tracker/screens/students_landing.dart';
import 'package:private_teaching_tracker/screens/students_new.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.black,
      accentColor: Colors.cyan[600],
    ),
    routes: {
      'home': (context) => Home(),
      'newStudent': (context) => NewStudent(),
      'allStudents': (context) => AllStudents(),
      'captureLessons': (context) => CaptureLessons(),
    },
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            //Navigator.of(context).pushNamed('captureLessons');
            Navigator.pushNamed(context, 'captureLessons');
            // Navigator.push(
            //   context,
            //   new MaterialPageRoute(
            //     builder: (context) => CaptureLessons(),
            //   ),
            // );
          },
          icon: Icon(Icons.add),
          label: Text("Capture Lesson"),
        ),
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                //icon: Icon(Icons.assessment_outlined),
                text: 'History',
              ),
              Tab(
                //icon: Icon(Icons.person),
                text: 'Students',
              ),
              Tab(
                //icon: Icon(Icons.attach_file),
                text: 'Report',
              )
            ],
          ),
          title: Text('SST - Simple Student Tracker'),
        ),
        body: TabBarView(
          children: [
            TeachingHistory(),
            StudentsLandingPage(),
            GenerateReports(),
          ],
        ),
      ),
    );
  }
}
