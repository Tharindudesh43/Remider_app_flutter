import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_to_do_app/models/tototask_model.dart';
import 'package:smart_to_do_app/providers/todotask_provider.dart';
import 'package:smart_to_do_app/screens/home_screen.dart';
import 'package:smart_to_do_app/services/firebase_service.dart';
import 'package:smart_to_do_app/widgets/to_do_list_card.dart';

class WorkTasks extends StatefulWidget {
  WorkTasks({super.key});

  @override
  State<WorkTasks> createState() => _WorkTasksState();
}

class _WorkTasksState extends State<WorkTasks> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseService.gettodotasks().then((ToDoTaskData) {
      context
          .read<TodotaskProvider>()
          .addalltodotasks_Provider(todotasks: ToDoTaskData);
    });
    FirebaseService.getCurrentUser_work_todotasks().then(
      (todoIds) {
        context
            .read<TodotaskProvider>()
            .addcurrentuser_workToDo_task_provider(todotask: todoIds!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Work Tasks",
            style: TextStyle(
                fontSize: 20,
                color: Colors.lightBlue,
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
                      .getOnlyCurrectusers_work_ToDoTasks();
                  List<ToDoTask?> allcurrentUser_Work_ToDoTasks =
                      todotasks.currentUser_work_todotasks;
                  print(
                      "LEN of all work task: ${allcurrentUser_Work_ToDoTasks.length}");
                  return allcurrentUser_Work_ToDoTasks.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: allcurrentUser_Work_ToDoTasks.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return ToDoListCard(
                              themecolor: Colors.lightBlue,
                              ToDoTaskData:
                                  allcurrentUser_Work_ToDoTasks[index]!,
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
