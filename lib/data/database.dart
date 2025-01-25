import 'package:hive_flutter/adapters.dart';

class ToDoDatabase {
  List toDoList = [];

  //reference the box
  final _mybox = Hive.box('mybox');

  // run the metehod if running the app first time ever
  void createInitialData() {
    toDoList = [
      ["Walk for 30mins", false],
      ["Exercise", false],
    ];
  }

  //load the data from database
  void loadData() {
    toDoList = _mybox.get("TODOLIST");
  }

  //update the database
  void updateDatabase() {
    _mybox.put('TODOLIST', toDoList);
  }
}
