import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_to_do_app/models/tototask_model.dart';
import 'package:smart_to_do_app/providers/todotask_provider.dart';
import 'package:smart_to_do_app/services/firebase_service.dart';
import 'package:intl/intl.dart';
import 'package:smart_to_do_app/widgets/to_do_form_card.dart';

class ToDoListCard extends StatefulWidget {
  final ToDoTask ToDoTaskData;
  const ToDoListCard({super.key, required this.ToDoTaskData});

  @override
  State<ToDoListCard> createState() => _ToDoListCardState();
}

class _ToDoListCardState extends State<ToDoListCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 350,
        height: 280,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            border: Border.all(
              color: const Color.fromARGB(255, 0, 0, 0),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.ToDoTaskData.title!,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Scrollbar(
                    //thumbVisibility: true,
                    thickness: 3,
                    radius: Radius.circular(10),
                    child: SingleChildScrollView(
                        child: Column(children: [
                      Text(
                        widget.ToDoTaskData.description!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ])),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(DateFormat('yyyy-MM-dd')
                  .format((widget.ToDoTaskData.date as Timestamp).toDate())!),
              Text(widget.ToDoTaskData.priority.toString()!),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text(
                      'Edit',
                      style:
                          TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 255, 94)),
                    onPressed: () {
                      ToDoFormCard obj = ToDoFormCard();
                      obj.DialogCard(
                          docid: widget.ToDoTaskData.id!,
                          whichform: false,
                          contextxx: context,
                          descriptionController:
                              widget.ToDoTaskData.description.toString(),
                          titleController: widget.ToDoTaskData.title.toString(),
                          datepassed: widget.ToDoTaskData.date!,
                          prioritypassed: widget.ToDoTaskData.priority!);
                    },
                  ),
                  TextButton(
                    child: Text(
                      'Delete',
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 181, 12, 12)),
                    onPressed: () {
                      FirebaseService.deleteCurrentUserToDoTask(
                          taskId: widget.ToDoTaskData.id!);

                      FirebaseService.gettodotasks().then((ToDoTaskData) {
                        print("Can't get all tasks from firebase");
                        context
                            .read<TodotaskProvider>()
                            .addalltodotasks_Provider(todotasks: ToDoTaskData);
                        context
                            .read<TodotaskProvider>()
                            .removeCurrentuserToDOTasks(
                                taskId: widget.ToDoTaskData.id!);

                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Deleted a Task"),
                          behavior: SnackBarBehavior.floating,
                          elevation: 12,
                        ));
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
