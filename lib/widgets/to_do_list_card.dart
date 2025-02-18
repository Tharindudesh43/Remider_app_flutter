import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_to_do_app/models/tototask_model.dart';
import 'package:smart_to_do_app/providers/todotask_provider.dart';
import 'package:smart_to_do_app/services/firebase_service.dart';
import 'package:intl/intl.dart';
import 'package:smart_to_do_app/widgets/to_do_form_card.dart';
import 'package:google_fonts/google_fonts.dart';

class ToDoListCard extends StatefulWidget {
  final ToDoTask ToDoTaskData;
  final Color themecolor;
  const ToDoListCard({
    super.key,
    required this.ToDoTaskData,
    required this.themecolor,
  });

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
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
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
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.ToDoTaskData.title!,
                    style: GoogleFonts.phudu(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.ToDoTaskData.description!,
                    style: GoogleFonts.archivo(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    key: widget.key,
                    children: [
                      const Icon(Icons.access_time,
                          size: 14, color: Color.fromARGB(255, 0, 0, 0)),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('yyyy-MM-dd').format(
                            (widget.ToDoTaskData.date as Timestamp).toDate())!,
                        style: GoogleFonts.archivo(
                            fontSize: 12,
                            color: widget.themecolor,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.low_priority_rounded,
                          size: 14, color: Color.fromARGB(255, 0, 0, 0)),
                      const SizedBox(width: 0),
                      Text(" ${widget.ToDoTaskData.priority.toString()!}",
                          style: GoogleFonts.archivo(
                              color:
                                  widget.ToDoTaskData.priority == "Top Priority"
                                      ? Colors.red
                                      : widget.ToDoTaskData.priority ==
                                              "Low Priority"
                                          ? Colors.lightBlueAccent
                                          : Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                      // Text(widget.ToDoTaskData.tasktype.toString()!,
                      //     style: TextStyle(
                      //         color: Colors.purple, fontSize: 15)),
                      const SizedBox(width: 20),
                      Container(
                          width: 35,
                          height: 35,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 0, 38, 255),
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
                                    if (widget.ToDoTaskData.status == "not") {
                                      context
                                          .read<TodotaskProvider>()
                                          .removeCurrentuser_not_complete_personal_ToDOTaskIds(
                                              taskId: widget.ToDoTaskData.id!);
                                      context
                                          .read<TodotaskProvider>()
                                          .removealltodotask_provider(
                                              taskId: widget.ToDoTaskData.id!);
                                      context
                                          .read<TodotaskProvider>()
                                          .remove_current_user_not_completed_personal_ToDoTasks(
                                              taskid: widget.ToDoTaskData.id!);
                                      context
                                          .read<TodotaskProvider>()
                                          .removeCurrentuser_personal_ToDOTaskList(
                                              taskId: widget.ToDoTaskData.id!);
                                      context
                                          .read<TodotaskProvider>()
                                          .removeCurrentuser_personal_ToDOTaskIds(
                                              taskId: widget.ToDoTaskData.id!);
                                    }
                                  } else if (widget.ToDoTaskData.tasktype ==
                                      "Work") {
                                    if (widget.ToDoTaskData.status == "not") {
                                      context
                                          .read<TodotaskProvider>()
                                          .removeCurrentuser_not_complete_work_ToDOTaskIds(
                                              taskId: widget.ToDoTaskData.id!);
                                      context
                                          .read<TodotaskProvider>()
                                          .removealltodotask_provider(
                                              taskId: widget.ToDoTaskData.id!);
                                      context
                                          .read<TodotaskProvider>()
                                          .remove_current_user_not_completed_work_ToDoTasks(
                                              taskid: widget.ToDoTaskData.id!);
                                      context
                                          .read<TodotaskProvider>()
                                          .removeCurrentuser_work_ToDOTaskList(
                                              taskId: widget.ToDoTaskData.id!);
                                      context
                                          .read<TodotaskProvider>()
                                          .removeCurrentuser_work_ToDOTaskIds(
                                              taskId: widget.ToDoTaskData.id!);
                                    }
                                  } else if (widget.ToDoTaskData.tasktype ==
                                      "Health") {
                                    if (widget.ToDoTaskData.status == "not") {
                                      context
                                          .read<TodotaskProvider>()
                                          .removeCurrentuser_not_complete_health_ToDOTaskIds(
                                              taskId: widget.ToDoTaskData.id!);
                                      context
                                          .read<TodotaskProvider>()
                                          .removealltodotask_provider(
                                              taskId: widget.ToDoTaskData.id!);
                                      context
                                          .read<TodotaskProvider>()
                                          .remove_current_user_not_completed_health_ToDoTasks(
                                              taskid: widget.ToDoTaskData.id!);
                                      context
                                          .read<TodotaskProvider>()
                                          .removeCurrentuser_health_ToDOTaskList(
                                              taskId: widget.ToDoTaskData.id!);
                                      context
                                          .read<TodotaskProvider>()
                                          .removeCurrentuser_health_ToDOTaskIds(
                                              taskId: widget.ToDoTaskData.id!);
                                    }
                                  } else if (widget.ToDoTaskData.tasktype ==
                                      "Social") {
                                    if (widget.ToDoTaskData.status == "not") {
                                      context
                                          .read<TodotaskProvider>()
                                          .removeCurrentuser_not_complete_social_ToDOTaskIds(
                                              taskId: widget.ToDoTaskData.id!);
                                      context
                                          .read<TodotaskProvider>()
                                          .removealltodotask_provider(
                                              taskId: widget.ToDoTaskData.id!);
                                      context
                                          .read<TodotaskProvider>()
                                          .remove_current_user_not_completed_social_ToDoTasks(
                                              taskid: widget.ToDoTaskData.id!);
                                      context
                                          .read<TodotaskProvider>()
                                          .removeCurrentuser_social_ToDOTaskList(
                                              taskId: widget.ToDoTaskData.id!);
                                      context
                                          .read<TodotaskProvider>()
                                          .removeCurrentuser_social_ToDOTaskIds(
                                              taskId: widget.ToDoTaskData.id!);
                                    }
                                  }

                                  FirebaseService.delete_level_of_complete();
                                  FirebaseService.get_level_of_complete()
                                      .then((value) {
                                    context
                                        .read<TodotaskProvider>()
                                        .add_level_of_complete(value: value);
                                  });

                                  Flushbar(
                                    message: "Deleted a Task",
                                    icon: Icon(
                                      Icons.delete_forever_outlined,
                                      size: 28.0,
                                      color: Color.fromARGB(255, 217, 38, 241),
                                    ),
                                    margin: EdgeInsets.all(6.0),
                                    flushbarStyle: FlushbarStyle.FLOATING,
                                    flushbarPosition: FlushbarPosition.BOTTOM,
                                    textDirection: Directionality.of(context),
                                    borderRadius: BorderRadius.circular(12),
                                    duration: Duration(seconds: 3),
                                    leftBarIndicatorColor:
                                        Color.fromARGB(255, 217, 38, 241),
                                  ).show(context);
                                  //Navigator.of(context).pop();
                                  // ScaffoldMessenger.of(context)
                                  //     .showSnackBar(const SnackBar(
                                  //   backgroundColor: Colors.deepPurple,
                                  //   shape: StadiumBorder(),
                                  //   behavior: SnackBarBehavior.floating,
                                  //   margin: EdgeInsets.all(20),
                                  //   content: Text(
                                  //     "Delete a Task",
                                  //     style: TextStyle(
                                  //         fontWeight: FontWeight.w500,
                                  //         fontSize: 15),
                                  //   ),
                                  //   elevation: 12,
                                  // ));
                                });
                              },
                              icon: const Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.white,
                              ))),
                      const SizedBox(width: 6),
                      Container(
                          width: 35,
                          height: 35,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 255, 115, 0),
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
                                        titleController: widget
                                            .ToDoTaskData.title
                                            .toString(),
                                        datepassed: widget.ToDoTaskData.date!,
                                        prioritypassed:
                                            widget.ToDoTaskData.priority!)
                                    .then((value) {});
                              },
                              icon: const Icon(
                                Icons.edit_document,
                                size: 20,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 238, 5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                    autofocus: true,
                    onPressed: () {
                      if (widget.ToDoTaskData.tasktype == "Personal") {
                        FirebaseService.add_level_of_complete();
                        context
                            .read<TodotaskProvider>()
                            .removeCurrentuser_not_complete_personal_ToDOTaskIds(
                                taskId: widget.ToDoTaskData.id!);
                        context
                            .read<TodotaskProvider>()
                            .remove_current_user_not_completed_personal_ToDoTasks(
                                taskid: widget.ToDoTaskData.id!);
                        context
                            .read<TodotaskProvider>()
                            .addcurrentuser_personal_completed_ToDotask_done_button(
                                todotaskId: widget.ToDoTaskData.id!);
                        FirebaseService.completedtAsk_update(
                            taskId: widget.ToDoTaskData.id!);
                      } else if (widget.ToDoTaskData.tasktype == "Work") {
                        FirebaseService.add_level_of_complete();
                        context
                            .read<TodotaskProvider>()
                            .removeCurrentuser_not_complete_work_ToDOTaskIds(
                                taskId: widget.ToDoTaskData.id!);
                        context
                            .read<TodotaskProvider>()
                            .remove_current_user_not_completed_work_ToDoTasks(
                                taskid: widget.ToDoTaskData.id!);
                        context
                            .read<TodotaskProvider>()
                            .addcurrentuser_work_completed_ToDotask_done_button(
                                todotaskId: widget.ToDoTaskData.id!);
                        FirebaseService.completedtAsk_update(
                            taskId: widget.ToDoTaskData.id!);
                      } else if (widget.ToDoTaskData.tasktype == "Health") {
                        FirebaseService.add_level_of_complete();
                        context
                            .read<TodotaskProvider>()
                            .removeCurrentuser_not_complete_health_ToDOTaskIds(
                                taskId: widget.ToDoTaskData.id!);
                        context
                            .read<TodotaskProvider>()
                            .remove_current_user_not_completed_health_ToDoTasks(
                                taskid: widget.ToDoTaskData.id!);
                        context
                            .read<TodotaskProvider>()
                            .addcurrentuser_health_completed_ToDotask_done_button(
                                todotaskId: widget.ToDoTaskData.id!);
                        FirebaseService.completedtAsk_update(
                            taskId: widget.ToDoTaskData.id!);
                      } else if (widget.ToDoTaskData.tasktype == "Social") {
                        FirebaseService.add_level_of_complete();
                        context
                            .read<TodotaskProvider>()
                            .removeCurrentuser_not_complete_social_ToDOTaskIds(
                                taskId: widget.ToDoTaskData.id!);
                        context
                            .read<TodotaskProvider>()
                            .remove_current_user_not_completed_social_ToDoTasks(
                                taskid: widget.ToDoTaskData.id!);
                        context
                            .read<TodotaskProvider>()
                            .addcurrentuser_social_completed_ToDotask_done_button(
                                todotaskId: widget.ToDoTaskData.id!);
                        FirebaseService.completedtAsk_update(
                            taskId: widget.ToDoTaskData.id!);
                      }

                      FirebaseService.add_level_of_complete();
                      Flushbar(
                        message: "Completed a Task",
                        icon: Icon(
                          Icons.add_task,
                          size: 28.0,
                          color: Color.fromARGB(255, 217, 38, 241),
                        ),
                        margin: EdgeInsets.all(6.0),
                        flushbarStyle: FlushbarStyle.FLOATING,
                        flushbarPosition: FlushbarPosition.BOTTOM,
                        textDirection: Directionality.of(context),
                        borderRadius: BorderRadius.circular(12),
                        duration: Duration(seconds: 3),
                        leftBarIndicatorColor:
                            Color.fromARGB(255, 217, 38, 241),
                      ).show(context);
                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      //   backgroundColor: Colors.deepPurple,
                      //   shape: StadiumBorder(),
                      //   behavior: SnackBarBehavior.floating,
                      //   margin: EdgeInsets.all(20),
                      //   content: Text(
                      //     "Completed a Task",
                      //     style: TextStyle(
                      //         fontWeight: FontWeight.w500, fontSize: 15),
                      //   ),
                      //   elevation: 12,
                      // ));
                      //});
                    },
                    icon: const Icon(
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
