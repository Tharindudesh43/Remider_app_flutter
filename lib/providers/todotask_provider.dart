import 'package:flutter/material.dart';
import 'package:smart_to_do_app/models/tototask_model.dart';

class TodotaskProvider extends ChangeNotifier {
  List<dynamic> _currentuserstodotaskids = [];
  List<ToDoTask> _todotasks = [];
  List<ToDoTask> _currentuserToDoTaskList = [];
  String? _name;

  addalltodotasks_Provider({required List<ToDoTask> todotasks}) {
    _todotasks = todotasks;
    notifyListeners();
  }

  addCurrentUserToDoTask_Provider(
      {required List<dynamic> currentuserstodotask}) {
    _currentuserstodotaskids = currentuserstodotask;
    notifyListeners();
  }

  getOnlyCurrectusersToDoTasks() {
    _currentuserToDoTaskList.clear();
    for (var todotask in _todotasks) {
      if (_currentuserstodotaskids.contains(todotask.id)) {
        _currentuserToDoTaskList.add(todotask);
      }
    }
  }

  updateCurrentuserToDOTasks({required String taskId}) {
    _currentuserstodotaskids.add(taskId);
    notifyListeners();
  }

  removeCurrentuserToDOTasks({required String taskId}) {
    _currentuserstodotaskids.remove(taskId);
    notifyListeners();
  }

  clearcurrentuserTasks() {
    _currentuserstodotaskids.clear();
    //_currentuserToDoTaskList.clear();
    //_todotasks.clear();
    notifyListeners();
  }

  addusername({required String name}) {
    _name = name;
    notifyListeners();
  }

  clearcurrentusername() {
    _name = "";
    notifyListeners();
  }

  List<dynamic> get currentuserstodotaskids => _currentuserstodotaskids;
  List<ToDoTask> get todotasksData => _todotasks;
  List<ToDoTask> get currentuserToDoTaskList => _currentuserToDoTaskList;
  String get username => _name!;
}
