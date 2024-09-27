import 'package:baghyar/data/models/program_group.dart';

class Day {
  Day(
      {this.number = 0,
      required this.date,
      this.passed = true,
      this.now = false});

  int number;
  DateTime date;
  bool passed;
  bool now;
  final List<ProgramGroup> programGroup =
      []; //var task = List<Task>.filled(3, Task()); //final List<Task> task = []; //
}
