import 'package:flutter/material.dart';
import 'package:private_teaching_tracker/common/globalVariables.dart';
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
      'studentsLandingPage': (context) => StudentsLandingPage(),
      'newStudent': (context) => NewStudent(),
      'allStudents': (context) => AllStudents(),
      'captureLessons': (context) => CaptureLessons(),
    },
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    updateStudentGlobalData();
    updateHistoryGlobalData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          onPressed: () async {
            await updateStudentGlobalData();
            Navigator.pushNamed(context, 'captureLessons',
                arguments: allStudentsGV);
          },
          icon: Icon(Icons.add),
          label: Text("I'm teaching!"),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'History',
              ),
              Tab(
                text: 'Students',
              ),
              Tab(
                text: 'Report',
              )
            ],
          ),
          title: Text(
            'STT - Simple Teaching Tracker',
          ),
          centerTitle: true,
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
