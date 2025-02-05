import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_to_do_app/models/tototask_model.dart';
import 'package:smart_to_do_app/providers/todotask_provider.dart';
import 'package:smart_to_do_app/screens/home_screen.dart';
import 'package:smart_to_do_app/services/firebase_service.dart';
import 'package:smart_to_do_app/widgets/to_do_list_card.dart';

class PersonalTasks extends StatefulWidget {
  const PersonalTasks({super.key});

  @override
  State<PersonalTasks> createState() => _PersonalTasksState();
}

class _PersonalTasksState extends State<PersonalTasks> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseService.gettodotasks().then((ToDoTaskData) {
      context
          .read<TodotaskProvider>()
          .addalltodotasks_Provider(todotasks: ToDoTaskData);
    });
    FirebaseService.getCurrentUser_personal_todotasks().then(
      (todoIds) {
        context
            .read<TodotaskProvider>()
            .addcurrentuser_personalToDo_task_provider(todotask: todoIds!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Personal Tasks",
            style: TextStyle(
                fontSize: 20,
                color: const Color.fromARGB(238, 86, 0, 247),
                fontWeight: FontWeight.w500),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                icon: Icon(Icons.close)),
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: SizedBox(
              height: 350,
              width: double.infinity,
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Consumer<TodotaskProvider>(
                    builder: (context, todotasks, child) {
                  context
                      .read<TodotaskProvider>()
                      .getOnlyCurrectusers_personal_ToDoTasks();
                  List<ToDoTask?> allcurrentUser_Personal_ToDoTasks =
                      todotasks.currentUser_personal_todotasks;
                  print(
                      "Len of all personal task: ${allcurrentUser_Personal_ToDoTasks.length}");
                  return allcurrentUser_Personal_ToDoTasks.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: allcurrentUser_Personal_ToDoTasks.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, int index) {
                            return ToDoListCard(
                              themecolor: Color.fromARGB(238, 86, 0, 247),
                              ToDoTaskData:
                                  allcurrentUser_Personal_ToDoTasks[index]!,
                            );
                          },
                        );
                });
              }),
            )),
          ],
        ));
  }
}

// Consumer<TodotaskProvider>(
//         builder: (context, todotasks, child) {
//           context.read<TodotaskProvider>().getOnlyCurrectusersToDoTasks();
//           List<ToDoTask?> allcurrentUserToDoTasks =
//               todotasks.currentuserToDoTaskList!;
//           return allcurrentUserToDoTasks.isEmpty
//               ? const Center(
//                   child: CircularProgressIndicator(),
//                 )
//               : ListView.builder(
//                   controller: _scrollController,
//                   itemCount: allcurrentUserToDoTasks.length,
//                   scrollDirection: Axis.vertical,
//                   itemBuilder: (BuildContext context, int index) {
//                     return ToDoListCard(
//                       ToDoTaskData: allcurrentUserToDoTasks[index]!,
//                     );
//                   },
//                 );
//         },
//       ),
