//Class that holds the history variables that will be written to the DB
class LessonsHistory {
  int id;
  String name;
  String lessontype;
  int starttime;
  int finishtime;

  LessonsHistory(this.name, this.lessontype, this.starttime, this.finishtime);

  maptoUserMap() {
    return {
      'name': name,
      'lessontype': lessontype,
      'starttime': starttime,
      'finishtime': finishtime,
    };
  }

  static fromMap(Map c) {
    return LessonsHistory(
        c['name'], c['lessontype'], c['starttime'], c['finishtime']);
  }
}
