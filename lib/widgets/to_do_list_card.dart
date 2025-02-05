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
  final Color themecolor;
  const ToDoListCard(
      {super.key, required this.ToDoTaskData, required this.themecolor});

  @override
  State<ToDoListCard> createState() => _ToDoListCardState();
}

class _ToDoListCardState extends State<ToDoListCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 300,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 6,
              height: 80,
              decoration: BoxDecoration(
                color: widget.themecolor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.ToDoTaskData.title!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.ToDoTaskData.description!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    key: widget.key,
                    children: [
                      Icon(Icons.access_time,
                          size: 14, color: Color.fromARGB(255, 0, 0, 0)),
                      SizedBox(width: 4),
                      Text(
                        DateFormat('yyyy-MM-dd').format(
                            (widget.ToDoTaskData.date as Timestamp).toDate())!,
                        style:
                            TextStyle(fontSize: 13, color: widget.themecolor),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.low_priority_rounded,
                          size: 14, color: Color.fromARGB(255, 0, 0, 0)),
                      SizedBox(width: 2),
                      Text(widget.ToDoTaskData.priority.toString()!,
                          style: TextStyle(
                              color: widget.themecolor, fontSize: 13)),
                      // Text(widget.ToDoTaskData.tasktype.toString()!,
                      //     style: TextStyle(
                      //         color: Colors.purple, fontSize: 15)),
                      SizedBox(width: 20),
                      Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                              autofocus: true,
                              onPressed: () {
                                FirebaseService.deleteCurrentUserToDoTask(
                                    taskId: widget.ToDoTaskData.id!);

                                FirebaseService.gettodotasks()
                                    .then((ToDoTaskData) {
                                  context
                                      .read<TodotaskProvider>()
                                      .addalltodotasks_Provider(
                                          todotasks: ToDoTaskData);

                                  if (widget.ToDoTaskData.tasktype ==
                                      "Personal") {
                                    context
                                        .read<TodotaskProvider>()
                                        .removeCurrentuser_personal_ToDOTask(
                                            taskId: widget.ToDoTaskData.id!);
                                  } else if (widget.ToDoTaskData.tasktype ==
                                      "Work") {
                                    context
                                        .read<TodotaskProvider>()
                                        .removeCurrentuser_work_ToDOTask(
                                            taskId: widget.ToDoTaskData.id!);
                                  } else if (widget.ToDoTaskData.tasktype ==
                                      "Health") {
                                    context
                                        .read<TodotaskProvider>()
                                        .removeCurrentuser_health_ToDOTask(
                                            taskId: widget.ToDoTaskData.id!);
                                  } else if (widget.ToDoTaskData.tasktype ==
                                      "Social") {
                                    context
                                        .read<TodotaskProvider>()
                                        .removeCurrentuser_health_ToDOTask(
                                            taskId: widget.ToDoTaskData.id!);
                                  }

                                  FirebaseService.delete_level_of_complete();
                                  FirebaseService.get_level_of_complete()
                                      .then((value) {
                                    context
                                        .read<TodotaskProvider>()
                                        .add_level_of_complete(value: value);
                                  });

                                  //Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    backgroundColor: Colors.deepPurple,
                                    shape: StadiumBorder(),
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.all(20),
                                    content: Text(
                                      "Delete a Task",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                    elevation: 12,
                                  ));
                                });
                              },
                              icon: Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.white,
                              ))),
                      SizedBox(width: 6),
                      Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                              autofocus: true,
                              onPressed: () {
                                ToDoFormCard obj = ToDoFormCard();
                                obj.DialogCard(
                                    pagenamepassed:
                                        widget.ToDoTaskData.tasktype!,
                                    tasktypepassed:
                                        widget.ToDoTaskData.tasktype!,
                                    docid: widget.ToDoTaskData.id!,
                                    whichform: false,
                                    contextxx: context,
                                    descriptionController: widget
                                        .ToDoTaskData.description
                                        .toString(),
                                    titleController:
                                        widget.ToDoTaskData.title.toString(),
                                    datepassed: widget.ToDoTaskData.date!,
                                    prioritypassed:
                                        widget.ToDoTaskData.priority!);
                              },
                              icon: Icon(
                                Icons.edit_document,
                                size: 20,
                                color: Colors.white,
                              ))),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 238, 5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                    autofocus: true,
                    onPressed: () {
                      FirebaseService.deleteCurrentUserToDoTask(
                          taskId: widget.ToDoTaskData.id!);

                      FirebaseService.gettodotasks().then((ToDoTaskData) {
                        context
                            .read<TodotaskProvider>()
                            .addalltodotasks_Provider(todotasks: ToDoTaskData);

                        if (widget.ToDoTaskData.tasktype == "Personal") {
                          context
                              .read<TodotaskProvider>()
                              .removeCurrentuser_personal_ToDOTask(
                                  taskId: widget.ToDoTaskData.id!);
                        } else if (widget.ToDoTaskData.tasktype == "Work") {
                          context
                              .read<TodotaskProvider>()
                              .removeCurrentuser_work_ToDOTask(
                                  taskId: widget.ToDoTaskData.id!);
                        } else if (widget.ToDoTaskData.tasktype == "Health") {
                          context
                              .read<TodotaskProvider>()
                              .removeCurrentuser_health_ToDOTask(
                                  taskId: widget.ToDoTaskData.id!);
                        } else if (widget.ToDoTaskData.tasktype == "Social") {
                          context
                              .read<TodotaskProvider>()
                              .removeCurrentuser_health_ToDOTask(
                                  taskId: widget.ToDoTaskData.id!);
                        }

                        FirebaseService.add_level_of_complete();

                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          backgroundColor: Colors.deepPurple,
                          shape: StadiumBorder(),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(20),
                          content: Text(
                            "Completed a Task",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                          elevation: 12,
                        ));
                      });
                    },
                    icon: Icon(
                      Icons.add_task,
                      size: 20,
                    ))),
          ],
        ),
      ),
    );

    //     Padding(
    //   padding: const EdgeInsets.all(10.0),
    //   child: Container(
    //     width: 350,
    //     height: 300,
    //     decoration: BoxDecoration(
    //         color: const Color.fromARGB(255, 255, 255, 255),
    //         border: Border.all(
    //           color: const Color.fromARGB(255, 0, 0, 0),
    //           width: 1,
    //         ),
    //         borderRadius: BorderRadius.circular(20)),
    //     child: Padding(
    //       padding: EdgeInsets.all(10.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    //             widget.ToDoTaskData.title!,
    //             style: const TextStyle(
    //                 color: Colors.black,
    //                 fontSize: 17,
    //                 fontWeight: FontWeight.w500),
    //           ),
    //           const SizedBox(
    //             height: 15,
    //           ),
    //           Container(
    //             height: 100,
    //             decoration: BoxDecoration(
    //               color: Colors.white,
    //               borderRadius: BorderRadius.circular(10),
    //               border: Border.all(
    //                 color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
    //                 width: 1,
    //               ),
    //             ),
    //             child: Padding(
    //               padding: const EdgeInsets.all(5.0),
    //               child: Scrollbar(
    //                 //thumbVisibility: true,
    //                 thickness: 3,
    //                 radius: Radius.circular(10),
    //                 child: SingleChildScrollView(
    //                     child: Column(children: [
    //                   Text(
    //                     widget.ToDoTaskData.description!,
    //                     style: const TextStyle(fontSize: 14),
    //                   ),
    //                 ])),
    //               ),
    //             ),
    //           ),
    //           const SizedBox(
    //             height: 15,
    //           ),
    //           Text(DateFormat('yyyy-MM-dd')
    //               .format((widget.ToDoTaskData.date as Timestamp).toDate())!),
    //           Text(widget.ToDoTaskData.priority.toString()!),
    //           Text(widget.ToDoTaskData.tasktype.toString()!),
    //           const SizedBox(
    //             height: 15,
    //           ),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               TextButton(
    //                 child: Text(
    //                   'Edit',
    //                   style:
    //                       TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
    //                 ),
    //                 style: TextButton.styleFrom(
    //                     backgroundColor: const Color.fromARGB(255, 0, 255, 94)),
    //                 onPressed: () {
    //                   ToDoFormCard obj = ToDoFormCard();
    //                   obj.DialogCard(
    //                       pagenamepassed: widget.ToDoTaskData.tasktype!,
    //                       tasktypepassed: widget.ToDoTaskData.tasktype!,
    //                       docid: widget.ToDoTaskData.id!,
    //                       whichform: false,
    //                       contextxx: context,
    //                       descriptionController:
    //                           widget.ToDoTaskData.description.toString(),
    //                       titleController: widget.ToDoTaskData.title.toString(),
    //                       datepassed: widget.ToDoTaskData.date!,
    //                       prioritypassed: widget.ToDoTaskData.priority!);
    //                 },
    //               ),
    //               TextButton(
    //                 child: Text(
    //                   'Delete',
    //                   style:
    //                       TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
    //                 ),
    //                 style: TextButton.styleFrom(
    //                     backgroundColor:
    //                         const Color.fromARGB(255, 181, 12, 12)),
    //                 onPressed: () {
    //                   FirebaseService.deleteCurrentUserToDoTask(
    //                       taskId: widget.ToDoTaskData.id!);

    //                   FirebaseService.gettodotasks().then((ToDoTaskData) {
    //                     context
    //                         .read<TodotaskProvider>()
    //                         .addalltodotasks_Provider(todotasks: ToDoTaskData);

    //                     if (widget.ToDoTaskData.tasktype == "Personal") {
    //                       context
    //                           .read<TodotaskProvider>()
    //                           .removeCurrentuser_personal_ToDOTask(
    //                               taskId: widget.ToDoTaskData.id!);
    //                     } else if (widget.ToDoTaskData.tasktype == "Work") {
    //                       context
    //                           .read<TodotaskProvider>()
    //                           .removeCurrentuser_work_ToDOTask(
    //                               taskId: widget.ToDoTaskData.id!);
    //                     } else if (widget.ToDoTaskData.tasktype == "Health") {
    //                       context
    //                           .read<TodotaskProvider>()
    //                           .removeCurrentuser_health_ToDOTask(
    //                               taskId: widget.ToDoTaskData.id!);
    //                     } else if (widget.ToDoTaskData.tasktype == "Social") {
    //                       context
    //                           .read<TodotaskProvider>()
    //                           .removeCurrentuser_health_ToDOTask(
    //                               taskId: widget.ToDoTaskData.id!);
    //                     }

    //                     // FirebaseService.delete_level_of_complete();
    //                     // FirebaseService.get_level_of_complete().then((value) {
    //                     //   context
    //                     //       .read<TodotaskProvider>()
    //                     //       .add_level_of_complete(level_compelet: value);
    //                     // });

    //                     ScaffoldMessenger.of(context)
    //                         .showSnackBar(const SnackBar(
    //                       content: Text("Deleted a Task"),
    //                       behavior: SnackBarBehavior.floating,
    //                       elevation: 12,
    //                     ));
    //                   });
    //                 },
    //               ),
    //             ],
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
