import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_to_do_app/models/tototask_model.dart';
import 'package:smart_to_do_app/providers/todotask_provider.dart';
import 'package:smart_to_do_app/screens/home_screen.dart';
import 'package:smart_to_do_app/services/firebase_service.dart';
import 'package:smart_to_do_app/widgets/to_do_list_card.dart';

class SocialTasks extends StatefulWidget {
  const SocialTasks({super.key});

  @override
  State<SocialTasks> createState() => _SocialTasksState();
}

class _SocialTasksState extends State<SocialTasks> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseService.gettodotasks().then((ToDoTaskData) {
      context
          .read<TodotaskProvider>()
          .addalltodotasks_Provider(todotasks: ToDoTaskData);
    });
    FirebaseService.getCurrentUser_social_todotasks().then(
      (todoIds) {
        context
            .read<TodotaskProvider>()
            .addcurrentuser_socialToDo_task_provider(todotask: todoIds!);
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Social Tasks",
            style: TextStyle(
                fontSize: 20,
                color: Colors.orange,
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
                      .getOnlyCurrectusers_social_ToDoTasks();
                  List<ToDoTask?> allcurrentUser_Social_ToDoTasks =
                      todotasks.currentUser_social_todotasks;
                  print(
                      "Len of all personal task: ${allcurrentUser_Social_ToDoTasks.length}");
                  return allcurrentUser_Social_ToDoTasks.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: allcurrentUser_Social_ToDoTasks.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return ToDoListCard(
                              themecolor: Colors.orange,
                              ToDoTaskData:
                                  allcurrentUser_Social_ToDoTasks[index]!,
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
