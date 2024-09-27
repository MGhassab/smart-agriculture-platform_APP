import 'day.dart';

class Week {
  //for (int j=0; j<7; j++) this.days[j].task.add(Task(isAddButton: true));
  var days = List<Day>.filled(7, Day(date: DateTime.now()));

//final List<Day> days = []; //// //
/*Week({
    this.days,
  });*/
//List<Day> days;
}

Week getEmptyWeek() {
  DateTime now = DateTime.now();
  // GITHUB print(now);
  DateTime temp = now.subtract(Duration(days: (now.weekday + 1) % 7));
  DateTime firstOfWeek = DateTime(temp.year, temp.month, temp.day);
  Week week = Week();
  for (int j = 0; j < 7; j++) {
    week.days[j] = Day(
        number: j,
        date: firstOfWeek.add(Duration(days: j)),
        passed: (j < ((now.weekday + 1) % 7)),
        now: (j == ((now.weekday + 1) % 7)));
  }
  return week;
}
