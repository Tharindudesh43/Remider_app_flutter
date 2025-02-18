import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_to_do_app/models/tototask_model.dart';

class TodotaskProvider extends ChangeNotifier {
  List<dynamic> _currentuserstodotaskids = [];
  List<ToDoTask> _todotasks = [];

  //----------
  List<dynamic> _currentusers_personal_todotasksids = []; //
  List<dynamic> _currentusers_personal_not_completed_todotasksids = [];
  List<dynamic> _currentusers_personal_completed_todotasksids = [];
  List<ToDoTask> _currentusers_personal_todotasksList = []; //
  List<ToDoTask> _currentusers_personal_completed_todotasksList = [];
  List<ToDoTask> _currentusers_personal_not_completed_todotasksList = []; //
  //------------

  //------------
  List<dynamic> _currentusers_health_todotasksids = [];
  List<dynamic> _currentusers_health_not_completed_todotasksids = [];
  List<dynamic> _currentusers_health_completed_todotasksids = [];
  List<ToDoTask> _currentusers_health_todotasksList = [];
  List<ToDoTask> _currentusers_health_completed_todotasksList = [];
  List<ToDoTask> _currentusers_health_not_completed_todotasksList = [];
  //------------

  //-----------
  List<dynamic> _currentusers_work_todotasksids = [];
  List<dynamic> _currentusers_work_not_completed_todotasksids = [];
  List<dynamic> _currentusers_work_completed_todotasksids = [];
  List<ToDoTask> _currentusers_work_todotasksList = [];
  List<ToDoTask> _currentusers_work_completed_todotasksList = [];
  List<ToDoTask> _currentusers_work_not_completed_todotasksList = [];
  //-----------

  //-----------
  List<dynamic> _currentusers_social_todotasksids = [];
  List<dynamic> _currentusers_social_not_completed_todotasksids = [];
  List<dynamic> _currentusers_social_completed_todotasksids = [];
  List<ToDoTask> _currentusers_social_todotasksList = [];
  List<ToDoTask> _currentusers_social_completed_todotasksList = [];
  List<ToDoTask> _currentusers_social_not_completed_todotasksList = [];
  //-----------

  List<ToDoTask> _currentuserToDoTaskList = [];
  String _name = "Empty";

  List<dynamic> _level_of_complete = [];

//[number_of_tasks,completed_tasks,left_tasks]
  List<dynamic> level_of_complete_personal_tasks = [];
  List<dynamic> level_of_complete_work_tasks = [];
  List<dynamic> level_of_complete_health_tasks = [];
  List<dynamic> level_of_complete_social_tasks = [];

  addalltodotasks_Provider({required List<ToDoTask> todotasks}) {
    _todotasks = todotasks;
    notifyListeners();
  }

  addCurrentUserToDoTask_Provider(
      {required List<dynamic> currentuserstodotask}) {
    _currentuserstodotaskids = currentuserstodotask;
    notifyListeners();
  }

  removealltodotask_provider({required String taskId}) {
    for (int x = 0; x < _todotasks.length; x++) {
      if (_todotasks[x].id == taskId) {
        _todotasks.removeAt(x);
        notifyListeners();
      }
    }
  }

//-----------------------------------------------------------
  add_level_of_compeletion_personal_tasks({required List<dynamic> value}) {
    level_of_complete_personal_tasks = value;
    notifyListeners();
  }

  reduce_level_of_completion_personal_tasks() {
    level_of_complete_personal_tasks[0] =
        level_of_complete_personal_tasks[0] + 1;
    level_of_complete_personal_tasks[2] =
        level_of_complete_personal_tasks[2] + 1;
    notifyListeners();
  }

  removeCurrentuser_personal_ToDOTask_update({required String taskId}) {
    for (int x = 0;
        x < _currentusers_personal_not_completed_todotasksids.length;
        x++) {
      if (_currentusers_personal_not_completed_todotasksids[x] == taskId) {
        _currentusers_personal_todotasksids.remove(taskId);
        _currentusers_personal_not_completed_todotasksids.remove(taskId);
        notifyListeners(); //
      }
    }
  }

  addcurrentuser_personal_not_complete_ToDotask_provider(
      {required List<dynamic> todotask}) {
    _currentusers_personal_not_completed_todotasksids = todotask;
    notifyListeners();
  }

  addcurrentuser_personal_completed_ToDotask_provider(
      {required List<dynamic> todotask}) {
    _currentusers_personal_completed_todotasksids = todotask;
    notifyListeners();
  }

  addcurrentuser_personal_completed_ToDotask_done_button(
      {required String todotaskId}) {
    _currentusers_personal_completed_todotasksids.add(todotaskId);
    notifyListeners();
  }

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

  getOnlyCurrectusers_personal_not_completed_ToDoTasks() {
    _currentusers_personal_not_completed_todotasksList.clear();
    for (var todotask in _todotasks) {
      if (_currentusers_personal_not_completed_todotasksids
          .contains(todotask.id)) {
        _currentusers_personal_not_completed_todotasksList.add(todotask);
      }
    }
  }

  getOnlyCurrectusers_personal_completed_ToDoTasks() {
    _currentusers_personal_completed_todotasksList.clear();
    for (var todotask in _todotasks) {
      if (_currentusers_personal_completed_todotasksids.contains(todotask.id)) {
        _currentusers_personal_completed_todotasksList.add(todotask);
      }
    }
  }

  get_updated_not_complete_personla_task_LIST(
      {required String taskId,
      required String title,
      required String description,
      required String priority,
      required DateTime date,
      required String tasktype}) {
    for (int x = 0;
        x < _currentusers_personal_not_completed_todotasksList.length;
        x++) {
      if (_currentusers_personal_not_completed_todotasksList[x].id == taskId) {
        _currentusers_personal_not_completed_todotasksList[x].date =
            Timestamp.fromDate(date);
        _currentusers_personal_not_completed_todotasksList[x].title = title;
        _currentusers_personal_not_completed_todotasksList[x].description =
            description;
        _currentusers_personal_not_completed_todotasksList[x].priority =
            priority;
        _currentusers_personal_not_completed_todotasksList[x].tasktype =
            tasktype;
        notifyListeners();
      }
    }
  }

  removeCurrentuser_personal_ToDOTaskList({required String taskId}) {
    for (int x = 0; x < _currentusers_personal_todotasksList.length; x++) {
      if (_currentusers_personal_todotasksList[x].id == taskId) {
        _currentusers_personal_todotasksList.removeAt(x);
        notifyListeners();
      }
    }
  }

  removeCurrentuser_personal_ToDOTaskIds({required String taskId}) {
    for (int x = 0; x < _currentusers_personal_todotasksids.length; x++) {
      if (_currentusers_personal_todotasksids[x] == taskId) {
        _currentusers_personal_todotasksids.removeAt(x);
        notifyListeners();
      }
    }
  }

  removeCurrentuser_not_complete_personal_ToDOTaskIds(
      {required String taskId}) {
    for (int x = 0;
        x < _currentusers_personal_not_completed_todotasksids.length;
        x++) {
      if (_currentusers_personal_not_completed_todotasksids[x] == taskId) {
        _currentusers_personal_not_completed_todotasksids.remove("$taskId");
        notifyListeners();
      }
    }
  }

  current_user_completed_personal_ToDoTasks({required String taskId}) {
    for (int x = 0; x < _currentusers_personal_todotasksList.length; x++) {
      if (_currentusers_personal_todotasksList[x].id == taskId) {
        // _currentusers_personal_todotasksList.remove(x);
        for (var todotask in _todotasks) {
          if (_currentusers_personal_todotasksids.contains(todotask.id)) {
            _currentusers_personal_completed_todotasksList.add(todotask);
            notifyListeners();
          }
        }
      }
    }
  }

  remove_current_user_completed_personal_ToDoTasks({required String taskid}) {
    for (int x = 0;
        x < _currentusers_personal_completed_todotasksids.length;
        x++) {
      if (_currentusers_personal_completed_todotasksids[x] == taskid) {
        _currentusers_personal_completed_todotasksids.remove("$taskid");
        _currentusers_personal_todotasksids.remove("$taskid");
        notifyListeners();
      }
    }
  }

  remove_current_user_not_completed_personal_ToDoTasks(
      {required String taskid}) {
    for (int x = 0;
        x < _currentusers_personal_not_completed_todotasksList.length;
        x++) {
      if (_currentusers_personal_not_completed_todotasksList[x].id == taskid) {
        _currentusers_personal_not_completed_todotasksList.removeAt(x);
        //notifyListeners();
      }
    }
  }

  clearcurrentuser_personal_Tasks() {
    _currentusers_personal_todotasksids.clear();
    notifyListeners();
  }
  //-------------------------------------------------------------

//---------------------------------------------------------------

  getOnlyCurrectusers_health_not_completed_ToDoTasks() {
    _currentusers_health_not_completed_todotasksList.clear();
    for (var todotask in _todotasks) {
      if (_currentusers_health_not_completed_todotasksids
          .contains(todotask.id)) {
        _currentusers_health_not_completed_todotasksList.add(todotask);
      }
    }
  }

  removeCurrentuser_not_complete_health_ToDOTaskIds({required String taskId}) {
    for (int x = 0;
        x < _currentusers_health_not_completed_todotasksids.length;
        x++) {
      if (_currentusers_health_not_completed_todotasksids[x] == taskId) {
        _currentusers_health_not_completed_todotasksids.remove("$taskId");
        notifyListeners();
      }
    }
  }

  remove_current_user_not_completed_health_ToDoTasks({required String taskid}) {
    for (int x = 0;
        x < _currentusers_health_not_completed_todotasksList.length;
        x++) {
      if (_currentusers_health_not_completed_todotasksList[x].id == taskid) {
        _currentusers_health_not_completed_todotasksList.removeAt(x);
        //notifyListeners();
      }
    }
  }

  addcurrentuser_health_completed_ToDotask_done_button(
      {required String todotaskId}) {
    _currentusers_health_completed_todotasksids.add(todotaskId);
    notifyListeners();
  }

  addcurrentuser_health_completed_ToDotask_provider(
      {required List<dynamic> todotask}) {
    _currentusers_health_completed_todotasksids = todotask;
    notifyListeners();
  }

  getOnlyCurrectusers_health_completed_ToDoTasks() {
    _currentusers_health_completed_todotasksList.clear();
    for (var todotask in _todotasks) {
      if (_currentusers_health_completed_todotasksids.contains(todotask.id)) {
        _currentusers_health_completed_todotasksList.add(todotask);
      }
    }
  }

  addcurrentuser_health_not_complete_ToDotask_provider(
      {required List<dynamic> todotask}) {
    _currentusers_health_not_completed_todotasksids = todotask;
    notifyListeners();
  }

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

  get_updated_not_complete_health_task_LIST(
      {required String taskId,
      required String title,
      required String description,
      required String priority,
      required DateTime date,
      required String tasktype}) {
    for (int x = 0;
        x < _currentusers_health_not_completed_todotasksList.length;
        x++) {
      if (_currentusers_health_not_completed_todotasksList[x].id == taskId) {
        _currentusers_health_not_completed_todotasksList[x].date =
            Timestamp.fromDate(date);
        _currentusers_health_not_completed_todotasksList[x].title = title;
        _currentusers_health_not_completed_todotasksList[x].description =
            description;
        _currentusers_health_not_completed_todotasksList[x].priority = priority;
        _currentusers_health_not_completed_todotasksList[x].tasktype = tasktype;
        notifyListeners();
      }
    }
  }

  removeCurrentuser_health_ToDOTask({required String taskId}) {
    for (int x = 0; x < _currentusers_health_todotasksList.length; x++) {
      if (_currentusers_health_todotasksList[x].id == taskId) {
        _currentusers_health_todotasksList.remove(x);
        _currentusers_health_todotasksids.remove(taskId);
        notifyListeners();
      }
    }
  }

  removeCurrentuser_health_ToDOTask_update({required String taskId}) {
    for (int x = 0;
        x < _currentusers_health_not_completed_todotasksids.length;
        x++) {
      if (_currentusers_health_not_completed_todotasksids[x] == taskId) {
        _currentusers_health_todotasksids.remove(taskId);
        _currentusers_health_not_completed_todotasksids.remove(taskId);
        notifyListeners();
      }
    }
  }

  add_level_of_compeletion_health_tasks({required List<dynamic> value}) {
    level_of_complete_health_tasks = value;
    notifyListeners();
  }

  reduce_level_of_completion_health_tasks() {
    level_of_complete_health_tasks[0] = level_of_complete_health_tasks[0] + 1;
    level_of_complete_health_tasks[2] = level_of_complete_health_tasks[2] + 1;
    notifyListeners();
  }

  remove_current_user_completed_health_ToDoTasks({required String taskid}) {
    for (int x = 0;
        x < _currentusers_health_completed_todotasksids.length;
        x++) {
      if (_currentusers_health_completed_todotasksids[x] == taskid) {
        _currentusers_health_completed_todotasksids.remove("$taskid");
        _currentusers_health_todotasksids.remove("$taskid");
        notifyListeners();
      }
    }
  }

  removeCurrentuser_health_ToDOTaskList({required String taskId}) {
    for (int x = 0; x < _currentusers_health_todotasksList.length; x++) {
      if (_currentusers_health_todotasksList[x].id == taskId) {
        _currentusers_health_todotasksList.removeAt(x);
        notifyListeners();
      }
    }
  }

  removeCurrentuser_health_ToDOTaskIds({required String taskId}) {
    for (int x = 0; x < _currentusers_health_todotasksids.length; x++) {
      if (_currentusers_health_todotasksids[x] == taskId) {
        _currentusers_health_todotasksids.removeAt(x);
        notifyListeners();
      }
    }
  }
//-------------------------------------------------------

//----------------------------------------------------
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

  addcurrentuser_work_completed_ToDotask_provider(
      {required List<dynamic> todotask}) {
    _currentusers_work_completed_todotasksids = todotask;
    notifyListeners();
  }

  getOnlyCurrectusers_work_completed_ToDoTasks() {
    _currentusers_work_completed_todotasksList.clear();
    for (var todotask in _todotasks) {
      if (_currentusers_work_completed_todotasksids.contains(todotask.id)) {
        _currentusers_work_completed_todotasksList.add(todotask);
      }
    }
  }

  getOnlyCurrectusers_work_not_completed_ToDoTasks() {
    _currentusers_work_not_completed_todotasksList.clear();
    for (var todotask in _todotasks) {
      if (_currentusers_work_not_completed_todotasksids.contains(todotask.id)) {
        _currentusers_work_not_completed_todotasksList.add(todotask);
      }
    }
  }

  addcurrentuser_work_not_complete_ToDotask_provider(
      {required List<dynamic> todotask}) {
    _currentusers_work_not_completed_todotasksids = todotask;
    notifyListeners();
  }

  get_updated_not_complete_work_task_LIST(
      {required String taskId,
      required String title,
      required String description,
      required String priority,
      required DateTime date,
      required String tasktype}) {
    for (int x = 0;
        x < _currentusers_work_not_completed_todotasksList.length;
        x++) {
      if (_currentusers_work_not_completed_todotasksList[x].id == taskId) {
        _currentusers_work_not_completed_todotasksList[x].date =
            Timestamp.fromDate(date);
        _currentusers_work_not_completed_todotasksList[x].title = title;
        _currentusers_work_not_completed_todotasksList[x].description =
            description;
        _currentusers_work_not_completed_todotasksList[x].priority = priority;
        _currentusers_work_not_completed_todotasksList[x].tasktype = tasktype;
        notifyListeners();
      }
    }
  }

  removeCurrentuser_work_ToDOTask({required String taskId}) {
    for (int x = 0; x < _currentusers_work_todotasksList.length; x++) {
      if (_currentusers_work_todotasksList[x].id == taskId) {
        _currentusers_work_todotasksList.remove(x);
        _currentusers_work_todotasksids.remove(taskId);
        notifyListeners();
      }
    }
  }

  remove_current_user_completed_work_ToDoTasks({required String taskid}) {
    for (int x = 0; x < _currentusers_work_completed_todotasksids.length; x++) {
      if (_currentusers_work_completed_todotasksids[x] == taskid) {
        _currentusers_work_completed_todotasksids.remove("$taskid");
        _currentusers_work_todotasksids.remove("$taskid");
        notifyListeners();
      }
    }
  }

  removeCurrentuser_not_complete_work_ToDOTaskIds({required String taskId}) {
    for (int x = 0;
        x < _currentusers_work_not_completed_todotasksids.length;
        x++) {
      if (_currentusers_work_not_completed_todotasksids[x] == taskId) {
        _currentusers_work_not_completed_todotasksids.remove("$taskId");
        notifyListeners();
      }
    }
  }

  remove_current_user_not_completed_work_ToDoTasks({required String taskid}) {
    for (int x = 0;
        x < _currentusers_work_not_completed_todotasksList.length;
        x++) {
      if (_currentusers_work_not_completed_todotasksList[x].id == taskid) {
        _currentusers_work_not_completed_todotasksList.removeAt(x);
        //notifyListeners();
      }
    }
  }

  removeCurrentuser_work_ToDOTaskList({required String taskId}) {
    for (int x = 0; x < _currentusers_work_todotasksList.length; x++) {
      if (_currentusers_work_todotasksList[x].id == taskId) {
        _currentusers_work_todotasksList.removeAt(x);
        notifyListeners();
      }
    }
  }

  removeCurrentuser_work_ToDOTaskIds({required String taskId}) {
    for (int x = 0; x < _currentusers_work_todotasksids.length; x++) {
      if (_currentusers_work_todotasksids[x] == taskId) {
        _currentusers_work_todotasksids.removeAt(x);
        notifyListeners();
      }
    }
  }

  removeCurrentuser_work_ToDOTask_update({required String taskId}) {
    for (int x = 0;
        x < _currentusers_work_not_completed_todotasksids.length;
        x++) {
      if (_currentusers_work_not_completed_todotasksids[x] == taskId) {
        _currentusers_work_todotasksids.remove(taskId);
        _currentusers_work_not_completed_todotasksids.remove(taskId);
        notifyListeners(); //
      }
    }
  }

  addcurrentuser_work_completed_ToDotask_done_button(
      {required String todotaskId}) {
    _currentusers_work_completed_todotasksids.add(todotaskId);
    notifyListeners();
  }

  add_level_of_compeletion_work_tasks({required List<dynamic> value}) {
    level_of_complete_work_tasks = value;
    notifyListeners();
  }

  reduce_level_of_completion_work_tasks() {
    level_of_complete_work_tasks[0] = level_of_complete_work_tasks[0] + 1;
    level_of_complete_work_tasks[2] = level_of_complete_work_tasks[2] + 1;
    notifyListeners();
  }
  //-----------------------------

  //-----------------------------
  getOnlyCurrectusers_social_not_completed_ToDoTasks() {
    _currentusers_social_not_completed_todotasksList.clear();
    for (var todotask in _todotasks) {
      if (_currentusers_social_not_completed_todotasksids
          .contains(todotask.id)) {
        _currentusers_social_not_completed_todotasksList.add(todotask);
      }
    }
  }

  addcurrentuser_social_not_complete_ToDotask_provider(
      {required List<dynamic> todotask}) {
    _currentusers_social_not_completed_todotasksids = todotask;
    notifyListeners();
  }

  getOnlyCurrectusers_social_completed_ToDoTasks() {
    _currentusers_social_completed_todotasksList.clear();
    for (var todotask in _todotasks) {
      if (_currentusers_social_completed_todotasksids.contains(todotask.id)) {
        _currentusers_social_completed_todotasksList.add(todotask);
      }
    }
  }

  addcurrentuser_social_completed_ToDotask_provider(
      {required List<dynamic> todotask}) {
    _currentusers_social_completed_todotasksids = todotask;
    notifyListeners();
  }

  addcurrentuser_socialToDo_task_provider({required List<dynamic> todotask}) {
    _currentusers_social_todotasksids = todotask;
    notifyListeners();
  }

  add_level_of_compeletion_social_tasks({required List<dynamic> value}) {
    level_of_complete_social_tasks = value;
    notifyListeners();
  }

  get_updated_not_social_task_LIST(
      {required String taskId,
      required String title,
      required String description,
      required String priority,
      required DateTime date,
      required String tasktype}) {
    for (int x = 0;
        x < _currentusers_social_not_completed_todotasksList.length;
        x++) {
      if (_currentusers_social_not_completed_todotasksList[x].id == taskId) {
        _currentusers_social_not_completed_todotasksList[x].date =
            Timestamp.fromDate(date);
        _currentusers_social_not_completed_todotasksList[x].title = title;
        _currentusers_social_not_completed_todotasksList[x].description =
            description;
        _currentusers_social_not_completed_todotasksList[x].priority = priority;
        _currentusers_social_not_completed_todotasksList[x].tasktype = tasktype;
        notifyListeners();
      }
    }
  }

  getOnlyCurrectusers_social_ToDoTasks() {
    _currentusers_social_todotasksList.clear();
    for (var todotask in _todotasks) {
      if (_currentusers_social_todotasksids.contains(todotask.id)) {
        _currentusers_social_todotasksList.add(todotask);
      }
    }
  }

  removeCurrentuser_social_ToDOTask_update({required String taskId}) {
    for (int x = 0;
        x < _currentusers_social_not_completed_todotasksids.length;
        x++) {
      if (_currentusers_social_not_completed_todotasksids[x] == taskId) {
        _currentusers_social_todotasksids.remove(taskId);
        _currentusers_social_not_completed_todotasksids.remove(taskId);
        notifyListeners();
      }
    }
  }

  reduce_level_of_completion_social_tasks() {
    level_of_complete_social_tasks[0] = level_of_complete_social_tasks[0] + 1;
    level_of_complete_social_tasks[2] = level_of_complete_social_tasks[2] + 1;
    notifyListeners();
  }

  removeCurrentuser_not_complete_social_ToDOTaskIds({required String taskId}) {
    for (int x = 0;
        x < _currentusers_social_not_completed_todotasksids.length;
        x++) {
      if (_currentusers_social_not_completed_todotasksids[x] == taskId) {
        _currentusers_social_not_completed_todotasksids.remove("$taskId");
        notifyListeners();
      }
    }
  }

  remove_current_user_not_completed_social_ToDoTasks({required String taskid}) {
    for (int x = 0;
        x < _currentusers_social_not_completed_todotasksList.length;
        x++) {
      if (_currentusers_social_not_completed_todotasksList[x].id == taskid) {
        _currentusers_social_not_completed_todotasksList.removeAt(x);
        //notifyListeners();
      }
    }
  }

  addcurrentuser_social_completed_ToDotask_done_button(
      {required String todotaskId}) {
    _currentusers_social_completed_todotasksids.add(todotaskId);
    notifyListeners();
  }

  removeCurrentuser_social_ToDOTaskList({required String taskId}) {
    for (int x = 0; x < _currentusers_social_todotasksList.length; x++) {
      if (_currentusers_social_todotasksList[x].id == taskId) {
        _currentusers_social_todotasksList.removeAt(x);
        notifyListeners();
      }
    }
  }

  removeCurrentuser_social_ToDOTaskIds({required String taskId}) {
    for (int x = 0; x < _currentusers_social_todotasksids.length; x++) {
      if (_currentusers_social_todotasksids[x] == taskId) {
        _currentusers_social_todotasksids.removeAt(x);
        notifyListeners();
      }
    }
  }

  remove_current_user_completed_social_ToDoTasks({required String taskid}) {
    for (int x = 0;
        x < _currentusers_social_completed_todotasksids.length;
        x++) {
      if (_currentusers_social_completed_todotasksids[x] == taskid) {
        _currentusers_social_completed_todotasksids.remove("$taskid");
        _currentusers_social_todotasksids.remove("$taskid");
        notifyListeners();
      }
    }
  }
  //------------------------------------------------------

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

  update_after_add_todo_level_complete() {
    _level_of_complete[1] = _level_of_complete[1] + 1;
    notifyListeners();
  }

  update_after_reduce_todo_level_complete() {
    _level_of_complete[1] = _level_of_complete[1] - 1;
    notifyListeners();
  }
  //--------------------

  List<dynamic> get currentuserstodotaskids => _currentuserstodotaskids;
  List<ToDoTask> get todotasksData => _todotasks;
  List<ToDoTask> get currentuserToDoTaskList => _currentuserToDoTaskList;
  String get username => _name;

//-----------------------------------------
  List<ToDoTask> get currentUser_personal_not_complete_todotasks =>
      _currentusers_personal_not_completed_todotasksList;
  List<ToDoTask> get currentUser_personal_completed_todotasks =>
      _currentusers_personal_completed_todotasksList;
//-----------------------------------------

//--------------------------------------------
  List<ToDoTask> get currentUser_work_not_complete_todotasks =>
      _currentusers_work_not_completed_todotasksList;
  List<ToDoTask> get currentUser_work_completed_todotasks =>
      _currentusers_work_completed_todotasksList;
//-------------------------------------------

//-------------------------------------------
  List<ToDoTask> get currentUser_health_not_complete_todotasks =>
      _currentusers_health_not_completed_todotasksList;
  List<ToDoTask> get currentUser_health_completed_todotasks =>
      _currentusers_health_completed_todotasksList;
//-------------------------------------------

//-------------------------------------------
  List<ToDoTask> get currentUser_social_not_complete_todotasks =>
      _currentusers_social_not_completed_todotasksList;
  List<ToDoTask> get currentUser_social_completed_todotasks =>
      _currentusers_social_completed_todotasksList;
//-------------------------------------------

  List<dynamic> get level_of_complete => _level_of_complete;
  List<dynamic> get level_of_completion_of_personal_tasks =>
      level_of_complete_personal_tasks;
  List<dynamic> get level_of_completion_of_work_tasks =>
      level_of_complete_work_tasks;
  List<dynamic> get level_of_completion_of_health_tasks =>
      level_of_complete_health_tasks;
  List<dynamic> get level_of_completion_of_social_tasks =>
      level_of_complete_social_tasks;
}
