import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_to_do_app/models/tototask_model.dart';
import 'package:smart_to_do_app/providers/todotask_provider.dart';
import 'package:smart_to_do_app/screens/home_screen.dart';
import 'package:smart_to_do_app/services/firebase_service.dart';
import 'package:smart_to_do_app/widgets/to_do_list_card.dart';

class HealthTasks extends StatefulWidget {
  const HealthTasks({super.key});

  @override
  State<HealthTasks> createState() => _HealthTasksState();
}

class _HealthTasksState extends State<HealthTasks> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseService.gettodotasks().then((ToDoTaskData) {
      context
          .read<TodotaskProvider>()
          .addalltodotasks_Provider(todotasks: ToDoTaskData);
    });
    FirebaseService.getCurrentUser_health_todotasks().then(
      (todoIds) {
        context
            .read<TodotaskProvider>()
            .addcurrentuser_healthToDo_task_provider(todotask: todoIds!);
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Health Tasks",
            style: TextStyle(
                fontSize: 20,
                color: const Color.fromARGB(255, 255, 2, 111),
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
                      .getOnlyCurrectusers_health_ToDoTasks();
                  List<ToDoTask?> allcurrentUser_health_ToDoTasks =
                      todotasks.currentUser_health_todotasks;
                  print(
                      "Len of all personal task: ${allcurrentUser_health_ToDoTasks.length}");
                  return allcurrentUser_health_ToDoTasks.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: allcurrentUser_health_ToDoTasks.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return ToDoListCard(
                              themecolor: Color.fromARGB(255, 255, 2, 111),
                              ToDoTaskData:
                                  allcurrentUser_health_ToDoTasks[index]!,
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
