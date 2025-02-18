import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_to_do_app/models/tototask_model.dart';

class FirebaseService {
  static Future<List<ToDoTask>> gettodotasks() async {
    try {
      CollectionReference todotaskCollectionreference =
          FirebaseFirestore.instance.collection("to_do_tasks");

      final todotaskDocument = await todotaskCollectionreference.get();

      List<ToDoTask> ToDoTasks = [];

      for (var ToDoTasksDoc in todotaskDocument.docs) {
        ToDoTasks.add(ToDoTask(
            id: ToDoTasksDoc.id,
            date: ToDoTasksDoc["date"],
            description: ToDoTasksDoc["description"],
            priority: ToDoTasksDoc["priority"],
            title: ToDoTasksDoc["title"],
            tasktype: ToDoTasksDoc["tasktype"],
            status: ToDoTasksDoc["status"]));
      }

      print(" Find all todotasks : ${ToDoTasks[0].title}");
      return ToDoTasks;
    } catch (e) {
      print("Cant get all to do tasks: $e");
      return [];
    }
  }

//-------------------------------------------
  static Future<List<ToDoTask>> get_personal_not_completed_todotasks() async {
    try {
      CollectionReference todotaskCollectionreference =
          FirebaseFirestore.instance.collection("to_do_tasks");
      CollectionReference userCollectionreference =
          FirebaseFirestore.instance.collection("users");

      final todotaskDocument = await todotaskCollectionreference.get();
      final userDocId = await getCurrentUser();

      var document = await userCollectionreference.doc(userDocId).get();

      List<dynamic> current_user_todotaskIds = document["user_to_do_tasks"];

      List<ToDoTask> not_completed_ToDoTasks = [];

      for (var taskIds in current_user_todotaskIds) {
        for (var ToDoTasksDoc in todotaskDocument.docs) {
          if (ToDoTasksDoc["tasktype"] == "Personal" &&
              ToDoTasksDoc.id == taskIds &&
              ToDoTasksDoc["status"] == "not") {
            not_completed_ToDoTasks.add(ToDoTask(
                id: ToDoTasksDoc.id,
                date: ToDoTasksDoc["date"],
                description: ToDoTasksDoc["description"],
                priority: ToDoTasksDoc["priority"],
                title: ToDoTasksDoc["title"],
                tasktype: ToDoTasksDoc["tasktype"],
                status: ToDoTasksDoc["status"]));
          }
        }
      }

      print("SSS: ${not_completed_ToDoTasks[0]}");
      return not_completed_ToDoTasks;
    } catch (e) {
      print("Cant get all to do tasks: $e");
      return [];
    }
  }

  //-------------------------------------------

  //add registered user into firestore
  static addSignUser(
      {required String email,
      required String name,
      required String mobilenumber}) async {
    try {
      CollectionReference userCollectionReference =
          FirebaseFirestore.instance.collection("users");

      userCollectionReference.add({
        "email": email,
        "name": name,
        "mobilenumber": mobilenumber,
        "level_of_complete": [0, 0]
      });

      print("user add to firestore");
      return "user add to firestore";
    } catch (e) {
      return e;
    }
  }

//add user added tasks into firestore
  static Future<dynamic> addtodotask(
      {required String title,
      required String description,
      required String priority,
      required DateTime date,
      required String tasktype}) async {
    try {
      CollectionReference todotasksCollectionReference =
          FirebaseFirestore.instance.collection("to_do_tasks");

      DocumentReference docref = await todotasksCollectionReference.add({
        "title": title,
        "description": description,
        "priority": priority,
        "date": date,
        "tasktype": tasktype,
        "status": "not"
      });

      //FirebaseFirestore.instance.collection("users").where(docref.id);

      print("Task added");
      return docref.id;
    } catch (e) {
      print("error occure when adding process");
      return e;
    }
  }

  static getCurrentUser() async {
    var user = FirebaseAuth.instance.currentUser;
    var currentUserEmail = user!.email;
    print("Current user email: {$currentUserEmail}");

    final usersCollectionReference =
        FirebaseFirestore.instance.collection("users");
    QuerySnapshot documents = await usersCollectionReference
        .where('email', isEqualTo: currentUserEmail)
        .get();

    dynamic userDocId = documents.docs[0].id;

    //print(userDocId + " User GOT!");
    return userDocId;
  }

  static completedtAsk_update({required String taskId}) async {
    try {
      await FirebaseFirestore.instance
          .collection('to_do_tasks')
          .doc(taskId)
          .update({'status': "done"});
      print("Task Updated to as completed tasks!");
    } catch (e) {
      print("Completed Task added firestore Error: $e");
    }
  }

  static addtodotasktouser({required docid}) async {
    CollectionReference usersCollectionReference =
        FirebaseFirestore.instance.collection("users");

    final userDocId = await getCurrentUser();
    print("User ID Current: $userDocId");

    var document = await usersCollectionReference.doc(userDocId).get();

    try {
      if (document["user_to_do_tasks"] != null) {
        List<dynamic> user_to_do_tasks = document["user_to_do_tasks"];
        user_to_do_tasks.add(docid);

        usersCollectionReference
            .doc(userDocId)
            .update({'user_to_do_tasks': user_to_do_tasks}).then((val) {
          print("User TODO Task Added");
        });
        //if (document["level_of_complete"] != null) {
        List<dynamic> level_of_complete = document["level_of_complete"];

        int all_tasks = level_of_complete[1];
        int completed_tasks = level_of_complete[0];

        usersCollectionReference.doc(userDocId).update({
          'level_of_complete': [completed_tasks, all_tasks + 1]
        }).then((val) {
          print("added task to level_of_complete");
        });
        // }
      }
    } catch (e) {
      usersCollectionReference.doc(userDocId).update({
        'user_to_do_tasks': [docid]
      }).then((val) {});
    }
  }

  static Future<List<dynamic>?> getCurrentUserToDoTasks() async {
    final usersCollectionReference =
        FirebaseFirestore.instance.collection("users");
    final userDocId = await getCurrentUser();

    var document = await usersCollectionReference.doc(userDocId).get();

    try {
      if (document["user_to_do_tasks"] != null) {
        List<dynamic> usertodotasks = await document["user_to_do_tasks"];
        print("Current User ToDo Tasks: $usertodotasks");

        return usertodotasks;
      } else {
        print("Current User ToDo Tasks: Empty");
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>?>
      getCurrentUser_personal_not_completed_todotasks() async {
    final usersCollectionReference =
        FirebaseFirestore.instance.collection("users");
    final todotasksCollectionReference =
        FirebaseFirestore.instance.collection("to_do_tasks");
    final userDocId = await getCurrentUser();

    List<dynamic> currentuser_personal_tasks = [];

    var document = await usersCollectionReference.doc(userDocId).get();
    try {
      if (document["user_to_do_tasks"] != null) {
        List<dynamic> usertodotasks = await document["user_to_do_tasks"];

        for (var todotask in usertodotasks) {
          var documenttodotask =
              await todotasksCollectionReference.doc(todotask).get();
          if (documenttodotask["tasktype"] == "Personal" &&
              documenttodotask["status"] == "not") {
            currentuser_personal_tasks.add(todotask);
          }
        }

        print(
            "Current user Personal not completed Tasks: $currentuser_personal_tasks");
        return currentuser_personal_tasks;
      } else {
        print("Current user Personal not completed Tasks:: Empty");
        return [];
      }
      // return currentuser_personal_tasks;
    } catch (e) {
      print("Error getting not complete personal data: ${e}");
      return [];
    }
  }

  static Future<List<dynamic>?> getCurrentUser_personal_todotasks() async {
    final usersCollectionReference =
        FirebaseFirestore.instance.collection("users");
    final todotasksCollectionReference =
        FirebaseFirestore.instance.collection("to_do_tasks");
    final userDocId = await getCurrentUser();

    List<dynamic> currentuser_personal_tasks = [];

    var document = await usersCollectionReference.doc(userDocId).get();

    try {
      if (document["user_to_do_tasks"] != null) {
        List<dynamic> usertodotasks = await document["user_to_do_tasks"];
        print("Current User ToDo Tasks: $usertodotasks");

        for (var todotask in usertodotasks) {
          var documenttodotask =
              await todotasksCollectionReference.doc(todotask).get();

          if (documenttodotask["tasktype"] == "Personal") {
            currentuser_personal_tasks.add(todotask);
          }
        }

        print("Current user Personal Tasks: $currentuser_personal_tasks");
        return currentuser_personal_tasks;
      } else {
        print("Current user Personal Tasks:: Empty");
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>?>
      getCurrentUser_personal_completed_todotasks() async {
    final usersCollectionReference =
        FirebaseFirestore.instance.collection("users");
    final todotasksCollectionReference =
        FirebaseFirestore.instance.collection("to_do_tasks");
    final userDocId = await getCurrentUser();

    List<dynamic> currentuser_completed_personal_tasks = [];

    var document = await usersCollectionReference.doc(userDocId).get();

    try {
      if (document["user_to_do_tasks"] != null) {
        List<dynamic> usertodotasks = await document["user_to_do_tasks"];

        for (var todotask in usertodotasks) {
          var documenttodotask =
              await todotasksCollectionReference.doc(todotask).get();

          if (documenttodotask["tasktype"] == "Personal" &&
              documenttodotask["status"] == "done") {
            currentuser_completed_personal_tasks.add(todotask);
          }
        }

        print(
            "Current user Personal completed Tasks: $currentuser_completed_personal_tasks");
        return currentuser_completed_personal_tasks;
      } else {
        print("Current user Personal completed Tasks:: Empty");
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>> get_level_of_complete() async {
    final usersCollectionReference =
        FirebaseFirestore.instance.collection("users");
    final userDocId = await getCurrentUser();
    var document = await usersCollectionReference.doc(userDocId).get();

    List<dynamic> level_of_complete = [];

    try {
      if (document["level_of_complete"] != null) {
        level_of_complete = await document["level_of_complete"];
        print("Current User level_of_task_compleion: $level_of_complete");

        return level_of_complete;
      } else {
        print("Current User ToDo Tasks: Empty");
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>?> get_level_of_personal_tasks() async {
    try {
      List<dynamic>? personal_completed_list =
          await getCurrentUser_personal_completed_todotasks();
      List<dynamic>? personal_not_completed_list =
          await getCurrentUser_personal_not_completed_todotasks();

      List<dynamic> level_of_personal_tasks = [
        personal_not_completed_list!.length + personal_completed_list!.length,
        personal_completed_list!.length,
        personal_not_completed_list!.length
      ];
      return level_of_personal_tasks;
    } catch (e) {
      print("Error while getting personal tasks completion history: $e");
    }
  }

  static Future<List<dynamic>?> get_level_of_work_tasks() async {
    try {
      List<dynamic>? work_completed_list =
          await getCurrentUser_work_completed_todotasks();
      List<dynamic>? work_not_completed_list =
          await getCurrentUser_work_not_completed_todotasks();

      List<dynamic> level_of_work_tasks = [
        work_not_completed_list!.length + work_completed_list!.length,
        work_completed_list!.length,
        work_not_completed_list!.length
      ];
      return level_of_work_tasks;
    } catch (e) {
      print("Error while getting work tasks completion history: $e");
    }
  }

  static Future<List<dynamic>?> get_level_of_health_tasks() async {
    try {
      List<dynamic>? health_completed_list =
          await getCurrentUser_health_completed_todotasks();
      List<dynamic>? health_not_completed_list =
          await getCurrentUser_health_not_completed_todotasks();

      List<dynamic> level_of_health_tasks = [
        health_not_completed_list!.length + health_completed_list!.length,
        health_completed_list!.length,
        health_not_completed_list!.length
      ];
      return level_of_health_tasks;
    } catch (e) {
      print("Error while getting health tasks completion history: $e");
    }
  }

  static Future<List<dynamic>?> get_level_of_social_tasks() async {
    try {
      List<dynamic>? social_completed_list =
          await getCurrentUser_social_completed_todotasks();
      List<dynamic>? social_not_completed_list =
          await getCurrentUser_social_not_completed_todotasks();

      List<dynamic> level_of_social_tasks = [
        social_not_completed_list!.length + social_completed_list!.length,
        social_completed_list!.length,
        social_not_completed_list!.length
      ];
      return level_of_social_tasks;
    } catch (e) {
      print("Error while getting social tasks completion history: $e");
    }
  }

//--------------------------------------------------------------------
  static Future<List<dynamic>?>
      getCurrentUser_social_not_completed_todotasks() async {
    final usersCollectionReference =
        FirebaseFirestore.instance.collection("users");
    final todotasksCollectionReference =
        FirebaseFirestore.instance.collection("to_do_tasks");
    final userDocId = await getCurrentUser();

    List<dynamic> currentuser_social_tasks = [];

    var document = await usersCollectionReference.doc(userDocId).get();
    try {
      if (document["user_to_do_tasks"] != null) {
        List<dynamic> usertodotasks = await document["user_to_do_tasks"];

        for (var todotask in usertodotasks) {
          var documenttodotask =
              await todotasksCollectionReference.doc(todotask).get();
          if (documenttodotask["tasktype"] == "Social" &&
              documenttodotask["status"] == "not") {
            currentuser_social_tasks.add(todotask);
          }
        }

        print(
            "Current user social not completed Tasks: $currentuser_social_tasks");
        return currentuser_social_tasks;
      } else {
        print("Current user social not completed Tasks:: Empty");
        return [];
      }
    } catch (e) {
      print("Error getting not complete social data: ${e}");
      return [];
    }
  }

  static Future<List<dynamic>?>
      getCurrentUser_social_completed_todotasks() async {
    final usersCollectionReference =
        FirebaseFirestore.instance.collection("users");
    final todotasksCollectionReference =
        FirebaseFirestore.instance.collection("to_do_tasks");
    final userDocId = await getCurrentUser();

    List<dynamic> currentuser_completed_social_tasks = [];

    var document = await usersCollectionReference.doc(userDocId).get();

    try {
      if (document["user_to_do_tasks"] != null) {
        List<dynamic> usertodotasks = await document["user_to_do_tasks"];

        for (var todotask in usertodotasks) {
          var documenttodotask =
              await todotasksCollectionReference.doc(todotask).get();

          if (documenttodotask["tasktype"] == "Social" &&
              documenttodotask["status"] == "done") {
            currentuser_completed_social_tasks.add(todotask);
          }
        }

        print(
            "Current user social completed Tasks: $currentuser_completed_social_tasks");
        return currentuser_completed_social_tasks;
      } else {
        print("Current user social completed Tasks:: Empty");
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>?> getCurrentUser_social_todotasks() async {
    final usersCollectionReference =
        FirebaseFirestore.instance.collection("users");
    final todotasksCollectionReference =
        FirebaseFirestore.instance.collection("to_do_tasks");
    final userDocId = await getCurrentUser();

    List<dynamic> currentuser_social_tasks = [];

    var document = await usersCollectionReference.doc(userDocId).get();

    try {
      if (document["user_to_do_tasks"] != null) {
        List<dynamic> usertodotasks = await document["user_to_do_tasks"];
        print("Current User ToDo Tasks: $usertodotasks");

        for (var todotask in usertodotasks) {
          var documenttodotask =
              await todotasksCollectionReference.doc(todotask).get();

          if (documenttodotask["tasktype"] == "Social") {
            currentuser_social_tasks.add(todotask);
          }
        }

        print("Current user Social Tasks: $currentuser_social_tasks");
        return currentuser_social_tasks;
      } else {
        print("Current User Health ToDo Tasks: Empty");
        return [];
      }
    } catch (e) {
      return [];
    }
  }
//------------------------------------------------------

//------------------------------------------------------
  static Future<List<dynamic>?> getCurrentUser_health_todotasks() async {
    final usersCollectionReference =
        FirebaseFirestore.instance.collection("users");
    final todotasksCollectionReference =
        FirebaseFirestore.instance.collection("to_do_tasks");
    final userDocId = await getCurrentUser();

    List<dynamic> currentuser_health_tasks = [];

    var document = await usersCollectionReference.doc(userDocId).get();

    try {
      if (document["user_to_do_tasks"] != null) {
        List<dynamic> usertodotasks = await document["user_to_do_tasks"];
        print("Current User ToDo Tasks: $usertodotasks");

        for (var todotask in usertodotasks) {
          var documenttodotask =
              await todotasksCollectionReference.doc(todotask).get();

          if (documenttodotask["tasktype"] == "Health") {
            currentuser_health_tasks.add(todotask);
          }
        }

        print("Current user Health Tasks: $currentuser_health_tasks");
        return currentuser_health_tasks;
      } else {
        print("Current User ToDo Tasks: Empty");
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>?>
      getCurrentUser_health_completed_todotasks() async {
    final usersCollectionReference =
        FirebaseFirestore.instance.collection("users");
    final todotasksCollectionReference =
        FirebaseFirestore.instance.collection("to_do_tasks");
    final userDocId = await getCurrentUser();

    List<dynamic> currentuser_completed_health_tasks = [];

    var document = await usersCollectionReference.doc(userDocId).get();

    try {
      if (document["user_to_do_tasks"] != null) {
        List<dynamic> usertodotasks = await document["user_to_do_tasks"];

        for (var todotask in usertodotasks) {
          var documenttodotask =
              await todotasksCollectionReference.doc(todotask).get();

          if (documenttodotask["tasktype"] == "Health" &&
              documenttodotask["status"] == "done") {
            currentuser_completed_health_tasks.add(todotask);
          }
        }

        print(
            "Current user Health completed Tasks: $currentuser_completed_health_tasks");
        return currentuser_completed_health_tasks;
      } else {
        print("Current user Health completed Tasks:: Empty");
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>?>
      getCurrentUser_health_not_completed_todotasks() async {
    final usersCollectionReference =
        FirebaseFirestore.instance.collection("users");
    final todotasksCollectionReference =
        FirebaseFirestore.instance.collection("to_do_tasks");
    final userDocId = await getCurrentUser();

    List<dynamic> currentuser_health_tasks = [];

    var document = await usersCollectionReference.doc(userDocId).get();
    try {
      if (document["user_to_do_tasks"] != null) {
        List<dynamic> usertodotasks = await document["user_to_do_tasks"];

        for (var todotask in usertodotasks) {
          var documenttodotask =
              await todotasksCollectionReference.doc(todotask).get();
          if (documenttodotask["tasktype"] == "Health" &&
              documenttodotask["status"] == "not") {
            currentuser_health_tasks.add(todotask);
          }
        }

        print(
            "Current user health not completed Tasks: $currentuser_health_tasks");
        return currentuser_health_tasks;
      } else {
        print("Current user health not completed Tasks:: Empty");
        return [];
      }
    } catch (e) {
      print("Error getting not complete health data: ${e}");
      return [];
    }
  }
//---------------------------------------------------------------------

//---------------------------------------------------------------------
  static Future<List<dynamic>?> getCurrentUser_work_todotasks() async {
    final usersCollectionReference =
        FirebaseFirestore.instance.collection("users");
    final todotasksCollectionReference =
        FirebaseFirestore.instance.collection("to_do_tasks");
    final userDocId = await getCurrentUser();

    List<dynamic> currentuser_work_tasks = [];

    var document = await usersCollectionReference.doc(userDocId).get();

    try {
      if (document["user_to_do_tasks"] != null) {
        List<dynamic> usertodotasks = await document["user_to_do_tasks"];
        print("Current User ToDo Tasks: $usertodotasks");

        for (var todotask in usertodotasks) {
          var documenttodotask =
              await todotasksCollectionReference.doc(todotask).get();

          if (documenttodotask["tasktype"] == "Work") {
            currentuser_work_tasks.add(todotask);
          }
        }

        print("Current user work Tasks: $currentuser_work_tasks");
        return currentuser_work_tasks;
      } else {
        print("Current User ToDo Tasks: Empty");
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>?>
      getCurrentUser_work_completed_todotasks() async {
    final usersCollectionReference =
        FirebaseFirestore.instance.collection("users");
    final todotasksCollectionReference =
        FirebaseFirestore.instance.collection("to_do_tasks");
    final userDocId = await getCurrentUser();

    List<dynamic> currentuser_completed_work_tasks = [];

    var document = await usersCollectionReference.doc(userDocId).get();

    try {
      if (document["user_to_do_tasks"] != null) {
        List<dynamic> usertodotasks = await document["user_to_do_tasks"];

        for (var todotask in usertodotasks) {
          var documenttodotask =
              await todotasksCollectionReference.doc(todotask).get();

          if (documenttodotask["tasktype"] == "Work" &&
              documenttodotask["status"] == "done") {
            currentuser_completed_work_tasks.add(todotask);
          }
        }

        print(
            "Current user Work completed Tasks: $currentuser_completed_work_tasks");
        return currentuser_completed_work_tasks;
      } else {
        print("Current user Work completed Tasks:: Empty");
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>?>
      getCurrentUser_work_not_completed_todotasks() async {
    final usersCollectionReference =
        FirebaseFirestore.instance.collection("users");
    final todotasksCollectionReference =
        FirebaseFirestore.instance.collection("to_do_tasks");
    final userDocId = await getCurrentUser();

    List<dynamic> currentuser_work_tasks = [];

    var document = await usersCollectionReference.doc(userDocId).get();
    try {
      if (document["user_to_do_tasks"] != null) {
        List<dynamic> usertodotasks = await document["user_to_do_tasks"];

        for (var todotask in usertodotasks) {
          var documenttodotask =
              await todotasksCollectionReference.doc(todotask).get();
          if (documenttodotask["tasktype"] == "Work" &&
              documenttodotask["status"] == "not") {
            currentuser_work_tasks.add(todotask);
          }
        }

        print("Current user Work not completed Tasks: $currentuser_work_tasks");
        return currentuser_work_tasks;
      } else {
        print("Current user Work not completed Tasks:: Empty");
        return [];
      }
    } catch (e) {
      print("error getting not complete work tasks: ${e}");
      return [];
    }
  }
  //-----------------------------------------------------------------------

  static Future<void> deleteCurrentUserToDoTask(
      {required String taskId}) async {
    CollectionReference usersCollectionReference =
        FirebaseFirestore.instance.collection("users");

    CollectionReference toDoTasksCollectionReference =
        FirebaseFirestore.instance.collection("to_do_tasks");

    final userDocId = await getCurrentUser();

    try {
      // Delete the task from the 'to_do_tasks' collection
      await toDoTasksCollectionReference.doc(taskId).delete();
      print("Task deleted from 'to_do_tasks' collection");

      // Get the user document
      DocumentSnapshot userDocument =
          await usersCollectionReference.doc(userDocId).get();

      if (userDocument.exists) {
        Map<String, dynamic>? userData =
            userDocument.data() as Map<String, dynamic>?;

        if (userData != null && userData["user_to_do_tasks"] != null) {
          List<dynamic> userToDoTasks = List.from(userData["user_to_do_tasks"]);
          userToDoTasks.remove(taskId);

          // Update the user document with the new list
          await usersCollectionReference
              .doc(userDocId)
              .update({"user_to_do_tasks": userToDoTasks});
          print("Deleted TODO Task from user collection");
        }
      }
    } catch (e) {
      print("Error deleting task: $e");
    }
  }

  static Future<List<ToDoTask>?> updatecurrentusertodotask({
    required String editdocid,
    required String title,
    required String description,
    required String priority,
    required String tasktype,
    required DateTime date,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('to_do_tasks')
          .doc(editdocid)
          .update({
        'title': title,
        'description': description,
        'priority': priority,
        'date': date,
        'tasktype': tasktype
      });
      print("Task Updated success!");
    } catch (e) {
      print("Error updating task: $e");
    }
  }

  static String addgoogleesigninuser({String? email, String? name}) {
    try {
      CollectionReference userCollectionReference =
          FirebaseFirestore.instance.collection("users");

      userCollectionReference.add({
        "email": email,
        "name": name,
        "mobilenumber": "",
        "level_of_complete": [0, 0]
      });
      print("google user add to firestore");
      return "user add to firestore";
    } catch (e) {
      return "$e";
    }
  }

  static Future<String> getCurruntUsername() async {
    final userDocId = await getCurrentUser();

    CollectionReference usersCollectionReference =
        FirebaseFirestore.instance.collection("users");

    var document = await usersCollectionReference.doc(userDocId).get();

    var currentdisplayname = document["name"];
    print(currentdisplayname.toString());
    return currentdisplayname.toString();
  }

  static balance_comleted_tasks_with_existing_data() async {
    CollectionReference usersCollectionReference =
        FirebaseFirestore.instance.collection("users");

    final userDocId = await getCurrentUser();

    var document = await usersCollectionReference.doc(userDocId).get();
    List<dynamic> current_tasks = document["user_to_do_tasks"];
    List<dynamic> level_of_complete = document["level_of_complete"];

    try {
      int all_tasks = current_tasks.length;
      int completed_tasks = 0;

      usersCollectionReference.doc(userDocId).update({
        'level_of_complete': [completed_tasks, all_tasks]
      }).then((val) {
        print("Update and balance level_of_complete");
      });
    } catch (e) {
      print("Error balance while level of complete: $e");
    }
  }

  static Future delete_level_of_complete() async {
    CollectionReference usersCollectionReference =
        FirebaseFirestore.instance.collection("users");

    final userDocId = await getCurrentUser();

    var document = await usersCollectionReference.doc(userDocId).get();

    try {
      if (document["level_of_complete"] != null) {
        List<dynamic> level_of_complete = document["level_of_complete"];

        int all_tasks = level_of_complete[1];
        int completed_tasks = level_of_complete[0];

        usersCollectionReference.doc(userDocId).update({
          'level_of_complete': [completed_tasks, all_tasks - 1]
        }).then((val) {
          print("remved task to level_of_complete");
        });
      }
    } catch (e) {
      print("Error Remove while level of complete: $e");
    }
  }

  static add_level_of_complete() async {
    CollectionReference usersCollectionReference =
        FirebaseFirestore.instance.collection("users");

    final userDocId = await getCurrentUser();

    var document = await usersCollectionReference.doc(userDocId).get();

    try {
      if (document["level_of_complete"] != null) {
        List<dynamic> level_of_complete = document["level_of_complete"];

        int all_tasks = level_of_complete[1];
        int completed_tasks = level_of_complete[0];

        usersCollectionReference.doc(userDocId).update({
          'level_of_complete': [completed_tasks + 1, all_tasks]
        }).then((val) {
          print("add task to level_of_complete");
        });
      }
    } catch (e) {
      print("Error adding while level of complete: $e");
    }
  }

  static reduce_level_of_complete() async {
    CollectionReference usersCollectionReference =
        FirebaseFirestore.instance.collection("users");

    final userDocId = await getCurrentUser();

    var document = await usersCollectionReference.doc(userDocId).get();

    try {
      if (document["level_of_complete"] != null) {
        List<dynamic> level_of_complete = document["level_of_complete"];

        int all_tasks = level_of_complete[1];
        int completed_tasks = level_of_complete[0];

        usersCollectionReference.doc(userDocId).update({
          'level_of_complete': [completed_tasks - 1, all_tasks - 1]
        }).then((val) {
          print("reduce task to level_of_complete");
        });
      }
    } catch (e) {
      print("Error reducing while level of complete: $e");
    }
  }
}
