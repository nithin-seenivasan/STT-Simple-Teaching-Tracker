//Class that holds the student variables that will be written to the DB
class Student {
  int id;
  String name;
  String lessontype;
  int lessonlength;

  Student(this.name, this.lessontype, this.lessonlength);

  maptoUserMap() {
    return {
      'name': name,
      'lessontype': lessontype,
      'lessonlength': lessonlength,
    };
  }

  static fromMap(Map c) {
    return Student(c['name'], c['lessontype'], c['lessonlength']);
  }
}
