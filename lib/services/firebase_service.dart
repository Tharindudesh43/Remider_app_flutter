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
        ));
      }

      print(" Find all todotasks : ${ToDoTasks[0].title}");
      return ToDoTasks;
    } catch (e) {
      print("Cant get all to do tasks: $e");
      return [];
    }
  }

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
      });

      print("user add to firestore");
      return "user add to firestore";
    } catch (e) {
      return e;
    }
  }

//add user added tasks into firestore
  static Future<dynamic> addtodotask({
    required String title,
    required String description,
    required String priority,
    required DateTime date,
  }) async {
    try {
      CollectionReference todotasksCollectionReference =
          FirebaseFirestore.instance.collection("to_do_tasks");

      DocumentReference docref = await todotasksCollectionReference.add({
        "title": title,
        "description": description,
        "priority": priority,
        "date": date
      });

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
      });
      print("Task Updated success!");
      return gettodotasks();
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
}
