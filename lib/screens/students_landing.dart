import 'package:flutter/material.dart';

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
          ],
        ),
      ),
    );
  }
}
