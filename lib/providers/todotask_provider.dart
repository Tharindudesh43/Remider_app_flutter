import 'package:flutter/material.dart';
import 'package:smart_to_do_app/models/tototask_model.dart';

class TodotaskProvider extends ChangeNotifier {
  List<dynamic> _currentuserstodotaskids = [];
  List<ToDoTask> _todotasks = [];

  //----------
  List<dynamic> _currentusers_personal_todotasksids = [];
  List<ToDoTask> _currentusers_personal_todotasksList = [];
  //------------

  //------------
  List<dynamic> _currentusers_health_todotasksids = [];
  List<ToDoTask> _currentusers_health_todotasksList = [];
  //------------

  //-----------
  List<dynamic> _currentusers_work_todotasksids = [];
  List<ToDoTask> _currentusers_work_todotasksList = [];
  //-----------

  //-----------
  List<dynamic> _currentusers_social_todotasksids = [];
  List<ToDoTask> _currentusers_social_todotasksList = [];
  //-----------

  List<ToDoTask> _currentuserToDoTaskList = [];
  String _name = "Empty";

  List<dynamic> _level_of_complete = [];

  addalltodotasks_Provider({required List<ToDoTask> todotasks}) {
    _todotasks = todotasks;
    notifyListeners();
  }

  addCurrentUserToDoTask_Provider(
      {required List<dynamic> currentuserstodotask}) {
    _currentuserstodotaskids = currentuserstodotask;
    notifyListeners();
  }

//-------------------------------
  addcurrentuser_personalToDo_task_provider({required List<dynamic> todotask}) {
    _currentusers_personal_todotasksids = todotask;
    notifyListeners();
  }

  getOnlyCurrectusers_personal_ToDoTasks() {
    _currentusers_personal_todotasksList.clear();
    for (var todotask in _todotasks) {
      if (_currentusers_personal_todotasksids.contains(todotask.id)) {
        _currentusers_personal_todotasksList.add(todotask);
      }
    }
  }

  removeCurrentuser_personal_ToDOTask({required String taskId}) {
    _currentusers_personal_todotasksids.remove(taskId);
    notifyListeners();
  }

  clearcurrentuser_personal_Tasks() {
    _currentusers_personal_todotasksids.clear();
    notifyListeners();
  }
  //-----------------------------

//-------------------------------
  addcurrentuser_healthToDo_task_provider({required List<dynamic> todotask}) {
    _currentusers_health_todotasksids = todotask;
    notifyListeners();
  }

  getOnlyCurrectusers_health_ToDoTasks() {
    _currentusers_health_todotasksList.clear();
    for (var todotask in _todotasks) {
      if (_currentusers_health_todotasksids.contains(todotask.id)) {
        _currentusers_health_todotasksList.add(todotask);
      }
    }
  }

  removeCurrentuser_health_ToDOTask({required String taskId}) {
    _currentusers_health_todotasksids.remove(taskId);
    notifyListeners();
  }
//-------------------------------

  //-----------------------------
  addcurrentuser_workToDo_task_provider({required List<dynamic> todotask}) {
    _currentusers_work_todotasksids = todotask;
    notifyListeners();
  }

  getOnlyCurrectusers_work_ToDoTasks() {
    _currentusers_work_todotasksList.clear();
    for (var todotask in _todotasks) {
      if (_currentusers_work_todotasksids.contains(todotask.id)) {
        _currentusers_work_todotasksList.add(todotask);
      }
    }
  }

  removeCurrentuser_work_ToDOTask({required String taskId}) {
    _currentusers_work_todotasksids.remove(taskId);
    notifyListeners();
  }
  //-----------------------------

  //-----------------------------
  addcurrentuser_socialToDo_task_provider({required List<dynamic> todotask}) {
    _currentusers_social_todotasksids = todotask;
    notifyListeners();
  }

  getOnlyCurrectusers_social_ToDoTasks() {
    _currentusers_social_todotasksList.clear();
    for (var todotask in _todotasks) {
      if (_currentusers_social_todotasksids.contains(todotask.id)) {
        _currentusers_social_todotasksList.add(todotask);
      }
    }
  }

  removeCurrentuser_social_ToDOTask({required String taskId}) {
    _currentusers_social_todotasksids.remove(taskId);
    notifyListeners();
  }
  //-----------------------------

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
    notifyListeners();
  }

//------------------------------------
  addusername({required String name}) {
    _name = name;
    notifyListeners();
  }

  clearcurrentusername() {
    _name = "";
    notifyListeners();
  }
  //-----------------------------------

  //--------------------
  add_level_of_complete({required List<dynamic> value}) {
    _level_of_complete = value;
    notifyListeners();
  }
  //--------------------

  List<dynamic> get currentuserstodotaskids => _currentuserstodotaskids;
  List<ToDoTask> get todotasksData => _todotasks;
  List<ToDoTask> get currentuserToDoTaskList => _currentuserToDoTaskList;
  String get username => _name;

  List<ToDoTask> get currentUser_personal_todotasks =>
      _currentusers_personal_todotasksList;
  List<ToDoTask> get currentUser_work_todotasks =>
      _currentusers_work_todotasksList;
  List<ToDoTask> get currentUser_health_todotasks =>
      _currentusers_health_todotasksList;
  List<ToDoTask> get currentUser_social_todotasks =>
      _currentusers_social_todotasksList;
  List<dynamic> get level_of_complete =>
      _level_of_complete;

}
